const text = "217795150000079043=30101204000";
const match = text.match(/0*\d*(\d{2})(?==)/);

if (match) {
  console.log(match[1]); // ✅ Outputs: 43
} else {
  console.log("No match found");
}

