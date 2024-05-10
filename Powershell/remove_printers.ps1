# remove printers in bulk
# go to the Printers tab in PaperCut
# export the list as CSV and save in the path var "csvPath"
# delete the first 2 lines as well as any printers you want to keep

$serverCommand = 'C:\Program Files\PaperCut MF\server\bin\win\server-command.exe'
$csvPath = 'C:\temp\printer_list.csv'
$csvData = Import-CSV $csvPath -Header server,printer

ForEach ($printer in $csvData) {
    &$serverCommand delete-printer $printer.server $printer.printer
	Write-Host "Removing printer..." $printer.printer
	#if the print queue is on the server, remove it so it doesn't add itself back
	if(Get-Printer -Name $printer.printer){		
		#Remove printer from server
		Remove-Printer $printer.printer -ErrorAction SilentlyContinue
	}
}