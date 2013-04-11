function arabic2roman(num:Number):String {
	var lookup:Object = {M:1000, CM:900, D:500, CD:400, C:100, XC:90, L:50, XL:40, X:10, IX:9, V:5, IV:4, I:1};
	var roman:String = "", i:String;
	for (i in lookup) {
		while (num >= lookup[i]) {
			roman += i;
			num -= lookup[i];
		}
	}
	return roman;
}
trace("1990 in roman is " + arabic2roman(1990));
trace("2008 in roman is " + arabic2roman(2008));
trace("1666 in roman is " + arabic2roman(1666));
