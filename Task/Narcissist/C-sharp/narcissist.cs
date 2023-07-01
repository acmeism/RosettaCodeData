using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
namespace Narcisisst
{
	class Program
	{
		public static void Main(string[] args)
		{
			const string path = @"E:\Narcisisst";
			string[] thisFile = Directory.GetFiles(path , "Program.cs");
			StringBuilder sb = new StringBuilder();
			
				foreach (string readLine in File.ReadLines(thisFile[0]))
				{
					sb.Append(readLine);
					sb.Append("\n");
				}
				
			Console.WriteLine(sb);
			string input =String.Empty;
			       	input = Console.ReadLine();
			       	Console.WriteLine((Regex.IsMatch(sb.ToString(),input))?"accept":"reject");
			       	Console.ReadKey();
			 }
	}
}
