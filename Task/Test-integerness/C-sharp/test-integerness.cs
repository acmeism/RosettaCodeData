namespace Test_integerness
{
	class Program
	{
		public static void Main(string[] args)
		{
			Console.Clear();
			Console.WriteLine();
			Console.WriteLine(" ***************************************************");
			Console.WriteLine(" *                                                 *");
			Console.WriteLine(" *              Integerness test                   *");
			Console.WriteLine(" *                                                 *");
			Console.WriteLine(" ***************************************************");
			Console.WriteLine();
			
			ConsoleKeyInfo key = new ConsoleKeyInfo('Y',ConsoleKey.Y,true,true,true);
			
			while(key.Key == ConsoleKey.Y)
			{
				// Get number value from keyboard
				Console.Write(" Enter number value : ");
				
				string LINE = Console.ReadLine();
				
				// Get tolerance value from keyboard
				Console.Write(" Enter tolerance value : ");
				
				double TOLERANCE = double.Parse(Console.ReadLine());
				
				
				// Resolve entered number format and set NUMBER value
				double NUMBER = 0;
				
				string [] N;
				
				// Real number value
				if(!double.TryParse(LINE, out NUMBER))
				{
					// Rational number value
					if(LINE.Contains("/"))
					{
						N = LINE.Split('/');
						
						NUMBER = double.Parse(N[0]) / double.Parse(N[1]);
					}
					// Inf value
					else if(LINE.ToUpper().Contains("INF"))
					{
						NUMBER = double.PositiveInfinity;
					}
					// Complex value
					else if(LINE.ToUpper().Contains("I"))
					{
						// Delete letter i
						LINE = LINE.ToUpper().Replace("I","");
						
						string r = string.Empty; // real part
						string i = string.Empty; // imaginary part
						
						int s = 1; // sign offset
						
						// Get sign
						if(LINE[0]=='+' || LINE[0]=='-')
						{
							r+=LINE[0].ToString();
							LINE = LINE.Remove(0,1);
							s--;
						}
						// Get real part
						foreach (char element in LINE)
						{
							if(element!='+' && element!='-')
								r+=element.ToString();
							else
								break;
						}
						// get imaginary part
						i = LINE.Substring(LINE.Length-(r.Length+s));
						
						NUMBER = double.Parse(i);
						if(NUMBER==0)
							NUMBER = double.Parse(r);
						else
							NUMBER = double.NaN;
						
					}
					// NaN value
					else
						NUMBER = double.NaN;
				}
				
				
				// Test
				bool IS_INTEGER = false;
				bool IS_INTEGER_T = false;
				
				if(double.IsNaN(NUMBER))
					IS_INTEGER=false;
				
				else if(Math.Round(NUMBER,0).ToString() == NUMBER.ToString())
					IS_INTEGER = true;
				
				else if((decimal)TOLERANCE >= (decimal)Math.Abs( (decimal)Math.Round(NUMBER,0) - (decimal)NUMBER ))
					IS_INTEGER_T = true;

				
				
				if(IS_INTEGER)
					Console.WriteLine(" Is exact integer " + IS_INTEGER);
				
				else
				{
					Console.WriteLine( " Is exact integer " + IS_INTEGER );
					Console.WriteLine( " Is integer with tolerance " + IS_INTEGER_T );
				}
				
				
				Console.WriteLine();
				Console.Write(" Another test < Y /N > . . . ");
				key  = Console.ReadKey(true);
				Console.WriteLine();
				Console.WriteLine();
			}
			
		}
		
	}
}
