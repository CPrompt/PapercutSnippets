# CSV file with the information for printer names and ports
$queuefile=import-csv printers_import.csv
# log file and message formatting
$logFile = "print_creation.log"


    # example
    # Write-Log -logText "Message to file"
# write log file
function Write-Log{
    param(
        [string]$logText
    )
    
    # Check to make sure it exists and if not create it
    if(-not(Test-Path $logFile)){
        New-Item -ItemType File -Path $logFile -Force
    }

    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timeStamp - $logText"

    #write to file
    $logMessage | Out-File -FilePath $logFile -Append
}



foreach ($line in $queuefile){
	
	if ($line.PrinterName -ne (Get-Printer -name $line.PrinterName -ErrorAction SilentlyContinue)) {
		Write-Host "Printer: "  $line.PrinterName  " doesn't exist..." -ForegroundColor Green
		# Check if printerport doesn't exist
		if ($line.PortAddress -ne (Get-PrinterPort -name $line.PortAddress -ErrorAction SilentlyContinue)) {
		# Add printerPort
			Write-Host "Port doesn't exist.  Adding printer port: "  $line.PortAddress -ForegroundColor Green
            Write-Log -logText "Added port:" $line.PortAddress            
			Add-PrinterPort -Name $line.PortAddress -PrinterHostAddress $line.PortAddress
		}else{
			Write-Host "Printer port with name $($printerPortName) already exists" -ForegroundColor Red
            Write-Log -logText "Printer already exisits:" $line.PortAddress
		}

	
    try {
    
        # right here we need to check if the printer is to be shared and if so, share it and set the share name
            if($line.Shared.ToLower() -eq "yes"){
                #add printer and share
                Add-Printer -Name $line.PrinterName -PortName $line.PortAddress -DriverName $line.DriverName -ShareName $line.ShareName -Shared -ErrorAction SilentlyContinue
                Write-Log -logText "Adding printer and sharing: " $line.PrinterName
            }else{
                # Add the printer
		        Add-Printer -N $line.PrinterName -PortName $line.PortAddress -DriverName $line.DriverName -ErrorAction SilentlyContinue
                Write-Log -logText "Adding printer: " $line.PrinterName
            }
	}catch{
		Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Log -logText $_.Exception.Message
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
		$printerport = Get-PrinterPort -Name $line.PortAddress
			if ($printerport.Description -eq "Standard TCP/IP Port") {
				$newport = $line.PortAddress.Insert(0,"PAPERCUT_")
					Write-Host "Adding keys to the registry for" $newport
					REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Monitors\PaperCut TCP/IP Port\Ports\$newport" /v HostName /t REG_SZ /d $printerPort.Name /f
					REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Monitors\PaperCut TCP/IP Port\Ports\$newport" /v PortNumber /t REG_DWORD /d 0x0000238c /f
                    Write-Log -logText "*** Converting to PaperCut ports..."
			}
	}
	Write-Host "Restarting the Print Spooler Service"
    Write-Log -logText  "Restarting the Print Spooler Service"
	Restart-Service -Name Spooler -Force
	foreach ($line in $queuefile){
		$printerport = Get-PrinterPort -Name $line.PortAddress
			if ($printerport.Description -eq "Standard TCP/IP Port") {
				$newport = $line.PortAddress.Insert(0,"PAPERCUT_") 
				Write-Host "Changing" $line..PrinterName "from port" $line.PortAddress "to" $newport
				Set-Printer $line.PrinterName -PortName $newport
                Write-Log  "Changing" $line..PrinterName "from port" $line.PortAddress "to" $newport
			}
	}
	
	
} else {
    Write-Host "Not converting print queues at this time..."
    Write-Log -logText "Skip PaperCut port conversion"
}

#turn off bi-direction support and advanced printing features for all printers
foreach ($line in $queuefile){
	cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prncnfg.vbs -t -p $line.PrinterName -enablebidi
	cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prncnfg.vbs -t -p $line.PrinterName +rawonly
	# set default to greyscale and turn off duplexing
	Set-PrintConfiguration $line.PrinterName -Color $false
	Set-PrintConfiguration $line.PrinterName -DuplexingMode 0
    Write-Log -logText "Setting configurations for printer: " $line.PrinterName
}