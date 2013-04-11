function repeatString(string:String, numTimes:uint):String
{
	var output:String = "";
	for(var i:uint = 0; i < numTimes; i++)
		output += string;
	return output;
}
