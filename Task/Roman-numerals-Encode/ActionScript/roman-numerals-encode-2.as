function roman2arabic(roman:String):Number {
	var romanArr:Array = roman.toUpperCase().split('');
	var lookup:Object = {I:1, V:5, X:10, L:50, C:100, D:500, M:1000};
	var num:Number = 0, val:Number = 0;
	while (romanArr.length) {
		val = lookup[romanArr.shift()];
		num += val * (val < lookup[romanArr[0]] ? -1 : 1);
	}
	return num;
}
trace("MCMXC in arabic is " + roman2arabic("MCMXC"));
trace("MMVIII in arabic is " + roman2arabic("MMVIII"));
trace("MDCLXVI in arabic is " + roman2arabic("MDCLXVI"));
