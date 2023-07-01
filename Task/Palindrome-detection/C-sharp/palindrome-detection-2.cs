using System;
using System.Linq;

class Program
{
	static bool IsPalindrome(string text)
	{
		return text == new String(text.Reverse().ToArray());
	}

	static void Main(string[] args)
	{
		Console.WriteLine(IsPalindrome("ingirumimusnocteetconsumimurigni"));
	}
}
