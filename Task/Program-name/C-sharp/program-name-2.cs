using System;
namespace ProgramName
{
	class Program
	{
		static void Main(string[] args)
		{
			// Extracts the filename from the full path
			System.IO.FileInfo exeInfo = new System.IO.FileInfo(System.Windows.Forms.Application.ExecutablePath);
			Console.Write(exeInfo.Name);
			
			// Writes all arguments to the console
			foreach (string argument in args)
			{
				Console.Write(" " + argument);
			}
		}
	}
}
