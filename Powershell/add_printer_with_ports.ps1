
# CSV file with the information for printer names and ports
$queuefile=import-csv printers.csv

foreach ($line in $queuefile){
	
	if ($line.PrinterName -ne (Get-Printer -name $line.PrinterName -ErrorAction SilentlyContinue)) {
		Write-Host "Printer: "  $line.PrinterName  " doesn't exist..." -ForegroundColor Green
		# Check if printerport doesn't exist
		if ($line.PortName -ne (Get-PrinterPort -name $line.PortAddress -ErrorAction SilentlyContinue)) {
		# Add printerPort
			Write-Host "Port doesn't exist.  Adding printer port: "  $line.PortName -ForegroundColor Green
			Add-PrinterPort -Name $line.PortName -PrinterHostAddress $line.PortAddress
		}else{
			Write-Host "Printer port with name $($printerPortName) already exists" -ForegroundColor Red
		}

	
    try {
		# Add the printer
		Add-Printer -N $line.PrinterName -PortName $line.PortName -DriverName $line.DriverName -ErrorAction stop
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
    #$printers = Get-Printer
	foreach ($line in $queuefile){
	#foreach ($printer in $printers) {
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
	#foreach ($printer in $printers) {
	foreach ($line in $queuefile){
		$printerport = Get-PrinterPort -Name $line.PortName
			if ($printerport.Description -eq "Standard TCP/IP Port") {
				$newport = $line.PortName.Insert(0,"PAPERCUT_") 
				Write-Host "Changing" $line.name "from port" $line.PortName "to" $newport
				Set-Printer $line.PrinterName -PortName $newport
			}
	}
	
	
} else {
    Write-Host 'Not converting print queues at this time...'
}





