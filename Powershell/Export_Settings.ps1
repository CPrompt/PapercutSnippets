# make the settings needed for each different manufacturer and run this.
# it will create a template *.dat file that can then be used to import with the 
# larger script

$reference_printers = "KM Testing", "GBO Reception"

foreach ($reference_printer in $reference_printers){
    $GPC = get-printconfiguration -PrinterName $reference_printer 
    RUNDLL32.EXE PRINTUI.DLL,PrintUIEntry /Ss /n $PNA /a C:\temp\$reference_printer.dat
}