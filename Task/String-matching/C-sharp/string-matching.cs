class Program
{
	public static void Main (string[] args)
	{
		var value = "abcd".StartsWith("ab");
		value = "abcd".EndsWith("zn"); //returns false
		value = "abab".Contains("bb"); //returns false
		value = "abab".Contains("ab"); //returns true
		int loc = "abab".IndexOf("bb"); //returns -1
		loc = "abab".IndexOf("ab"); //returns 0
		loc = "abab".IndexOf("ab",loc+1); //returns 2
	}
}
