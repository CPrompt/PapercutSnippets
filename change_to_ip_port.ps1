#SWITCH ALL PRINTERS FROM PAPERCUT TCP/IP PORTS TO STANDARD TCP/IP PORTS
$printers = Get-Printer
foreach ($printer in $printers){
    $printerport = Get-PrinterPort -Name $printer.PortName
        if ($printerport.Description -eq "PaperCut TCP/IP Port") {
            $newport = $printer.PortName.Trim("PAPERCUT_")
            Write-Host "Adding Standard TCP/IP Port" $newport "to replace PaperCut TCP/IP Port" $printer.PortName
            Add-PrinterPort $newport -PrinterHostAddress $newport -PortNumber 9100 -SNMP 1 -SNMPCommunity public
        }
}
Write-Host "Restarting the Print Spooler Service"
Restart-Service -Name Spooler -Force
foreach ($printer in $printers) {
    $printerport = Get-PrinterPort -Name $printer.PortName
        if ($printerport.Description -eq "PaperCut TCP/IP Port") {
            $newport = $printer.PortName.Trim("PAPERCUT_")
            Write-Host "Changing" $printer.name "from port" $printer.PortName "to" $newport
            Set-Printer $printer.name -PortName $newport
        }
}