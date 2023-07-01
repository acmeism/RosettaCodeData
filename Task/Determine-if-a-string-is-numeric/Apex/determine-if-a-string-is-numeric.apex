String numericString = '123456';
String partlyNumericString = '123DMS';
String decimalString = '123.456';

System.debug(numericString.isNumeric()); // this will be true
System.debug(partlyNumericString.isNumeric()); // this will be false
System.debug(decimalString.isNumeric()); // this will be false
System.debug(decimalString.remove('.').isNumeric()); // this will be true
