
# CSV file with the information for printer names and ports
$queuefile=import-csv printers_import.csv

foreach ($line in $queuefile){
	
	if ($line.Name -ne (Get-Printer -name $line.Name -ErrorAction SilentlyContinue)) {
		Write-Host "Printer: "  $line.Name  " doesn't exist..." -ForegroundColor Green
		# Check if printerport doesn't exist
		if ($line.PortName -ne (Get-PrinterPort -name $line.PortAddress -ErrorAction SilentlyContinue)) {
		# Add printerPort
			Write-Host "Port doesn't exist.  Adding printer port: "  $line.PortName -ForegroundColor Green
			Add-PrinterPort -Name $line.PortName -PrinterHostAddress $line.PortAddress
		}else{
			Write-Host "Printer port with name $($printerPortName) already exists" -ForegroundColor Red
		}

	
    try {
    
        # right here we need to check if the printer is to be shared and if so, share it and set the share name
            if($line.Shared.ToLower() -eq "yes"){
                #add printer and share
                Add-Printer -Name $line.Name -PortName $line.PortName -DriverName $line.DriverName -ShareName $line.ShareName -Shared -ErrorAction stop
            }else{
                # Add the printer
		        Add-Printer -N $line.Name -PortName $line.PortName -DriverName $line.DriverName -ErrorAction stop
            }
	}catch{
		Write-Host $_.Exception.Message -ForegroundColor Red
		break
    }
		Write-Host "Printer successfully installed" -ForegroundColor Green
	}else{
		Write-Warning "Printer already installed"
	}	
}

$title    = 'Confirm'
$question = 'Do you want to convert print queues to PaperCut print queues?'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
	#run the convertion for PaperCut ports
	foreach ($line in $queuefile){
		$printerport = Get-PrinterPort -Name $line.PortName
			if ($printerport.Description -eq "Standard TCP/IP Port") {
				$newport = $line.PortName.Insert(0,"PAPERCUT_")
					Write-Host "Adding keys to the registry for" $newport
					REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Monitors\PaperCut TCP/IP Port\Ports\$newport" /v HostName /t REG_SZ /d $printerPort.Name /f
					REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Monitors\PaperCut TCP/IP Port\Ports\$newport" /v PortNumber /t REG_DWORD /d 0x0000238c /f
			}
	}
	Write-Host "Restarting the Print Spooler Service"
	Restart-Service -Name Spooler -Force
	foreach ($line in $queuefile){
		$printerport = Get-PrinterPort -Name $line.PortName
			if ($printerport.Description -eq "Standard TCP/IP Port") {
				$newport = $line.PortName.Insert(0,"PAPERCUT_") 
				Write-Host "Changing" $line.name "from port" $line.PortName "to" $newport
				Set-Printer $line.Name -PortName $newport
			}
	}
	
	
} else {
    Write-Host 'Not converting print queues at this time...'
}

#turn off bi-direction support and advanced printing features for all printers
foreach ($line in $queuefile){
	cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prncnfg.vbs -t -p $line.Name -enablebidi
	cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prncnfg.vbs -t -p $line.Name +rawonly
	# set default to greyscale and turn off duplexing
	Set-PrintConfiguration $line.Name  $line.Name -Color $false
	Set-PrintConfiguration $line.Name  $line.Name -DuplexingMode 0
}
	



