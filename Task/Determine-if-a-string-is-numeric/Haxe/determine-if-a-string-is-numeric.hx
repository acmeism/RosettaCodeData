static function isNumeric(n:String):Bool
{
	if (Std.parseInt(n) != null) //Std.parseInt converts a string to an int
        {
		return true; //as long as it results in an integer, the function will return true
	}
        else
        {
		return false;
	}
}
