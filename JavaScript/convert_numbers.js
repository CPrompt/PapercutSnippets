/*
	Some KM devices need to have the reader in CCID mode
	so we are not able to do the conversion within the readers.
	
	When in CCID mode, the reader reads all information and return HEX
	
	This will read that number, convert it to binary,
	allow you to parse out the portion you need
	and then convert it to decimal
	
	
	Example:
		The numbers we need are 7074
		HEX: 8B8DD140
		Convert to Binary: 10001011100011011101000101000000
		7074 to Binary:                1101110100010
				Start at the 12th number and go until the 25th number
		
	
*/

function convert_numbers(cardNumber){
		// change these to where you need to strip the binary numbers
	var beginNumber = 12;
	var endNumber = 25;
	
	
	//convert Full number from hex to bin
	hex2bin = (parseInt(cardNumber, 16).toString(2)).padStart(8, '0');
	//strip out the part we need
	binStirp = hex2bin.substring(beginNumber, endNumber);
	//convert bin to dec
	digit = parseInt(binStirp, 2);
	
	//return the converted numbers
	return digit;
}


// Test 
//console.log(convert_numbers('8B8DD140'));