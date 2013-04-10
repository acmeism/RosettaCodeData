var value = "123.45e7"; // Assign string literal to value
if (isFinite(value)) {
  // value is a number
}
//Or, in web browser in address field:
//  javascript:value="123.45e4"; if(isFinite(value)) {alert('numeric')} else {alert('non-numeric')}
