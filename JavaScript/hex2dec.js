
//			10001011100011011101000101000000
					    1101110100010
//          			1101110100010			
//          8B8DD140

//			Full Hex 8B8DD140
//			10001011100011011101000101000000


function hex2bin(hex){
    return (parseInt(hex, 16).toString(2)).padStart(8, '0');
}

console.log(hex2bin('8B8DD140'));


function splitString(str) {
  var res = str.substring(12, 25);
  return res
}

var str = "10001011100011011101000101000000";
console.log(splitString(str));

