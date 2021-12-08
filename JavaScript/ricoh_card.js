/**
remove last 4 digits
**/

//8206429553108
//820642955

function convert(cardNumber){
	
	var cardLength = cardNumber.length;
	var newCardNumber;
	
	newCardNumber = cardNumber.substring(0, cardLength - 4);
	
	return newCardNumber;
}

//to test
//var card  = "00000000000000002769"
// newNumber = convert(card);
//document.write(newNumber);

var myNumber = "8206429553108"
console.log(convert(myNumber));
