############################################################################### 
#
# Add the printers to a computer that can be used for the reference
# of Print Deploy
#
###############################################################################
 
$queuefile=import-csv printers.csv


# take CSV file and edit it to add printer shares and full path
# this will be the method: add-printer -connectionname "\\printservername\printer share name"
# make sure the printer sharename has quotes around it


foreach ($line in $queuefile){
	Add-Printer -connectionname $line.PrinterName 
}
