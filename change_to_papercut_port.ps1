#SWITCH ALL PRINTERS FROM STANDARD TCP/IP PORTS TO PAPERCUT TCP/IP PORTS
$printers = Get-Printer
foreach ($printer in $printers) {
    $printerport = Get-PrinterPort -Name $printer.PortName
        if ($printerport.Description -eq "Standard TCP/IP Port") {
            $newport = $printer.PortName.Insert(0,"PAPERCUT_")
                Write-Host "Adding keys to the registry for" $newport
                REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Monitors\PaperCut TCP/IP Port\Ports\$newport" /v HostName /t REG_SZ /d $printerPort.Name /f
                REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Monitors\PaperCut TCP/IP Port\Ports\$newport" /v PortNumber /t REG_DWORD /d 0x0000238c /f
        }
}
Write-Host "Restarting the Print Spooler Service"
Restart-Service -Name Spooler -Force
foreach ($printer in $printers) {
    $printerport = Get-PrinterPort -Name $printer.PortName
        if ($printerport.Description -eq "Standard TCP/IP Port") {
            $newport = $printer.PortName.Insert(0,"PAPERCUT_") 
            Write-Host "Changing" $printer.name "from port" $printer.PortName "to" $newport
            Set-Printer $printer.name -PortName $newport
        }
}