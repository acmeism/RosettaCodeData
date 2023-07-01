using System;
using System.IO;

namespace Simple_database
{
	class Program
	{
		public static void Main(string[] args)
		{
			//
			// For appropriate use of this program
			// use standard Windows Command Processor or cmd.exe
			//
			// Create cmd.bat file at the same folder with executive version
			// of program Simple_database.exe, so when started, the correct
			// file path will be automatically set to cmd console.
			//
			// Start notepad, write only cmd.exe and save file as cmd.bat
			//
			// To start cmd just double click at cmd.bat file.
			//
			//
			//
			// Console application command line start command
			//
			// application name.exe [argument] [argument parameters]
			//
			//
			// Command line argument followed by parameters
			//
			// [a] - Add new entry
			//
			// ["data1"]["data2"]["data3"]...["data n"]
			//
			// ["data1"] - Data category !
			// ["data2"] - Data
			// ["data3"] - Data
			//
			//
			// NOTICE !
			//
			// First parameter is taken for data category.
			//
			//
			//
			// Command line argument with no parameters
			//
			// [p1] - Print the latest entry
			//
			// [p2] - Print the latest entry for each category
			//
			// [p3] - Print all entries sorted by a date
			//
			//
			//
			
			//
			// Command line example
			//
			// Small_database.exe [a] ["home"] ["+398125465458"] ["My tel number"]
			//
			// Small_database.exe [a] ["office"] ["+398222789000"] ["Boss"]
			//
			// Small_database.exe [a] [cd] ["Action movie"] ["Movie title"]
			// Small_database.exe [a] [cd] ["SF movie"] ["Movie title"]
			// Small_database.exe [a] [dvd] ["Action movie"] ["Movie title"]
			//
			//
			// NOTICE !
			//
			// Brackets and space between arguments and parameters are necessary.
			// Quotes must be used when parameters have more than one word.
			//
			// If not used as shown in examples, program will show error message.
			//
			//
			
			
			//
			// Check command line for arguments
			//
			//
			if(args.Length==0)
			{
				Console.WriteLine();
				Console.WriteLine(" Missing Argument Error. ");
				Console.WriteLine();
			}
			else
			{
				switch (args[0])
				{
						case "[a]" : Add_New_Entry(args);
						break;
						
						case "[p1]": Print_Document("Print the latest entry.txt");
						break;
						
						case "[p2]": Print_Document("Print the latest entry for each category.txt");
						break;
						
						case "[p3]": Print_Document("Print all entries sorted by a date.txt");
						break;
						
						default :
						{
							Console.WriteLine();
							Console.WriteLine(" Incorrect Argument Error. ");
							Console.WriteLine();
						}
						break;
				}
			}
		}
		
		static void Add_New_Entry(string [] args)
		{
			
			//
			// Check parameters
			//
			//
			// Minimum one parameter, category
			//
			if(args.Length==1)
			{
				Console.WriteLine();
				Console.WriteLine(" Missing Parameters Error..... ");
				Console.WriteLine();
			}
			else
			{
				bool parameters_ok = true;
				foreach (string a in args)
				{
					if(!a.StartsWith("[") || !a.EndsWith("]"))
					{
						parameters_ok = !parameters_ok;
						break;
					}
				}
				//
				// Add new entry to Data base document
				//
				if(parameters_ok)
				{
					//
					//
					//
					Console.WriteLine();
					Console.WriteLine(" Parameters are ok..... ");
					Console.WriteLine();
					Console.WriteLine(" Writing new entry to database..... ");
					//
					// Create new Data base entry
					//
					args[0] = string.Empty;
					string line = string.Empty;
					foreach (string a in args)
					{
						line+=a;
					}
					line+="[" + DateTime.Now.ToString() + "]";
					args[0] = "[" + DateTime.Now.ToString() + "]";
					//
					// Write entry to Data base
					//
					StreamWriter w = new StreamWriter("Data base.txt",true);
					w.WriteLine(line);
					//
					// Close and dispose stream writer
					//
					w.Close();
					w.Dispose();
					//
					//
					//
					Console.WriteLine();
					Console.WriteLine(" New entry is written to database. ");

					Create_Print_Documents(args);
					
					//
					//
					//
					Console.WriteLine();
					Console.WriteLine(" Add new entry command executed. ");
					//
					//
					//
				}
				else
				{
					Console.WriteLine();
					Console.WriteLine(" ! Parameters are not ok ! ");
					Console.WriteLine();
					Console.WriteLine(" Add new entry command is not executed. ");
					Console.WriteLine();
				}
			}
		}
		
		static void Create_Print_Documents(string [] args)
		{
			//
			//
			//
			Console.WriteLine();
			Console.WriteLine(" Creating new print documents. ");
			//
			// Create "Print all entries sorted by a date.txt"
			//
			File.Copy("Data base.txt","Print all entries sorted by a date.txt",true);
			//
			//
			//
			Console.WriteLine();
			Console.WriteLine(" Print all entries sorted by a date.txt created. ");
			//
			// Create "Print the latest entry.txt"
			//
			//
			// Create new entry
			//
			string line = string.Empty;
			foreach (string a in args)
			{
				line+=a;
			}
			//
			StreamWriter w = new StreamWriter("Print the latest entry.txt");
			//
			w.WriteLine(line);
			//
			w.Close();
			w.Dispose();
			//
			//
			//
			Console.WriteLine();
			Console.WriteLine(" Print the latest entry.txt created. ");
			//
			// Create "Print the latest entry for each category.txt"
			//
			string latest_entry = string.Empty;
			foreach (string a in args)
			{
				latest_entry+=a;
			}
			
			if(!File.Exists("Print the latest entry for each category.txt"))
			{
				File.WriteAllText("Print the latest entry for each category.txt",latest_entry);
			}
			else
			{
				StreamReader r = new StreamReader("Print the latest entry for each category.txt");
				//
				w = new StreamWriter("Print the latest entry for each category 1.txt",true);
				//
				line = string.Empty;
				//
				while(!r.EndOfStream)
				{
					line = r.ReadLine();
					if(line.Contains(args[1].ToString()))
					{
						w.WriteLine(latest_entry);
						latest_entry = "ok";
					}
					else
					{
						w.WriteLine(line);
					}
				}
				// add new category
				if(latest_entry != "ok")
					w.WriteLine(latest_entry);
				//
				w.Close();
				w.Dispose();
				//
				r.Close();
				r.Dispose();
				//
				File.Copy("Print the latest entry for each category 1.txt",
				          "Print the latest entry for each category.txt",true);
				//
				File.Delete("Print the latest entry for each category 1.txt");
				//
				//
				//
				Console.WriteLine();
				Console.WriteLine(" Print the latest entry for each category.txt created. ");
				Console.WriteLine();
			}
		}
		
		static void Print_Document(string file_name)
		{
			//
			// Print document
			//
			Console.WriteLine();
			Console.WriteLine(file_name.Replace(".txt","")+ " : ");
			Console.WriteLine();
			//
			StreamReader r = new StreamReader(file_name);
			//
			string line = string.Empty;
			//
			line = r.ReadToEnd();
			//
			Console.WriteLine(line);
			//
			r.Close();
			r.Dispose();
			//
			//
			//
		}
	}
}
