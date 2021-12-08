/*
	Some devices will interpret the numbers as ASCII and some 
	will output as decimal.
	
	Customer's cards were left as using ASCII encoding and users
	were already registered.
	
	Older devices seemed to not encode as ASCII so had to do the 
	opposite of the "ascii-enc" function that is built into PaperCut
	
	This will take the numbers and reformat them as ASCII
	
	
	Example:
		The numbers we need are 3233343333
		The card reader is seeing 23433
		You can see there is a "3" before each Number
		3233343333
		 2 3 4 3 3
*/
	
function convert(cardNumber){
	var arr1 = [];
	
	for (var n = 0, l = cardNumber.length; n < l; n ++){
		var hex = Number(cardNumber.charCodeAt(n)).toString(16);
		arr1.push(hex);
	 }
	 return arr1.join('');
}

//console.log(convert('23433'));