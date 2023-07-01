function repeatRecursive(string:String, numTimes:uint):String
{
	if(numTimes == 0) return "";
	if(numTimes & 1) return string + repeatRecursive(string, numTimes - 1);
	var tmp:String = repeatRecursive(string, numTimes/2);
	return tmp + tmp;
}
