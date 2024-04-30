# Curtis Adkins - 2023
# Export the printer information from servers


$printservers = "50-demohp380", "50-1933"

foreach ($printserver in $printservers){
	Get-WMIObject -class Win32_Printer -computer $printserver | Select Name,ShareName,DriverName,PortName  | Export-CSV -path 'C:\printers.csv'	
}	

