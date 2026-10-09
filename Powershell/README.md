This is a set of PowerShell scripts that I use for the initial deployment of PaperCut MF on a Windows server.

The 2 main pieces are "import_printers.ps1" and "printer_import.csv"

To use this script, simply edit the "printer_import.csv" to match the needs of the customers install.  Do not change the headers, just the data for each device.

Step 1:  Install the print driver(s) that will be used.  To obtain the name that is needed, open Print Management, locate the "Drivers" option and find the driver that will be used.  Right click and choose "Properties".  Copy the full "Name" that is shown including the letter case.

Step 2: Install PaperCut MF as needed.  This will install the print monitor that will include the ability to convert print queues from Standard TCP/IP to PaperCut ports.  This portion of the script was https://www.papercut.com/kb/Main/AutomaticallySetupThePaperCutPort/

Step 3: Run PowerShell as an administrtor and execute the "import_printers.ps1" script.  Make sure the print_import_csv file is either in the same path as the PS1 script, or you adjust the PS1 script to accomodate.

