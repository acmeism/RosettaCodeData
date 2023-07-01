using System;
using System.Collections;

namespace Egyptian_division
{
	class Program
	{
		public static void Main(string[] args)
		{
			Console.Clear();
			Console.WriteLine();
			Console.WriteLine(" Egyptian division ");
			Console.WriteLine();
			Console.Write(" Enter value of dividend : ");
			int dividend = int.Parse(Console.ReadLine());
			
			Console.Write(" Enter value of divisor : ");
			int divisor = int.Parse(Console.ReadLine());
			
			Divide(dividend, divisor);
			
			Console.WriteLine();
			Console.Write("Press any key to continue . . . ");
			Console.ReadKey(true);
			
			
			
		}
		
		static void Divide(int dividend, int divisor)
		{
			//
			// Local variable declaration and initialization
			//
			int result   = 0;
			int reminder = 0;
			
			int powers_of_two = 0;
			int doublings 	  = 0;
			
			int answer 	= 0;
			int accumulator = 0;
			
			int two = 2;
			int pow = 0;
			int row = 0;
			
			//
			// Tables declaration
			//
			ArrayList table_powers_of_two = new ArrayList();
			ArrayList table_doublings     = new ArrayList();
			
			//
			// Fill and Show table values
			//
			Console.WriteLine("                           ");
			Console.WriteLine(" powers_of_2     doublings ");
			Console.WriteLine("                           ");
			
			// Set initial values
			powers_of_two = 1;
			doublings = divisor;
			while( doublings <= dividend )
			{
				// Set table value
				table_powers_of_two.Add( powers_of_two );
				table_doublings.Add( doublings );
				
				// Show new table row
				Console.WriteLine("{0,8}{1,16}",powers_of_two, doublings);
				
				
				pow++;
				
				powers_of_two = (int)Math.Pow( two, pow );
				doublings = powers_of_two * divisor;
			}
			Console.WriteLine("                           ");
			
			//
			// Calculate division and Show table values
			//
			row = pow - 1;
			Console.WriteLine("                                                 ");
			Console.WriteLine(" powers_of_2     doublings   answer   accumulator");
			Console.WriteLine("                                                 ");
			Console.SetCursorPosition(Console.CursorLeft, Console.CursorTop + row);
			
			pow--;
			while( pow >= 0 && accumulator < dividend )
			{
				// Get values from tables
				doublings = int.Parse(table_doublings[pow].ToString());
				powers_of_two = int.Parse(table_powers_of_two[pow].ToString());
				
				if(accumulator + int.Parse(table_doublings[pow].ToString()) <= dividend )
				{
					// Set new values
					accumulator += doublings;
					answer += powers_of_two;
					
					// Show accumulated row values in different collor
					Console.ForegroundColor = ConsoleColor.Green;
					Console.Write("{0,8}{1,16}",powers_of_two, doublings);
					Console.ForegroundColor = ConsoleColor.Green;
					Console.WriteLine("{0,10}{1,12}", answer, accumulator);
					Console.SetCursorPosition(Console.CursorLeft, Console.CursorTop - 2);
				}
				else
				{
					// Show not accumulated row walues
					Console.ForegroundColor = ConsoleColor.DarkGray;
					Console.Write("{0,8}{1,16}",powers_of_two, doublings);
					Console.ForegroundColor = ConsoleColor.Gray;
					Console.WriteLine("{0,10}{1,12}", answer, accumulator);
					Console.SetCursorPosition(Console.CursorLeft, Console.CursorTop - 2);
				}
				
				
				pow--;
			}
			
			Console.WriteLine();
			Console.SetCursorPosition(Console.CursorLeft, Console.CursorTop + row + 2);
			Console.ResetColor();
			
			// Set result and reminder
			result = answer;
			if( accumulator < dividend )
			{
				reminder = dividend - accumulator;
				
				Console.WriteLine(" So " + dividend +
				                  " divided by " + divisor +
				                  " using the Egyptian method is \n " + result +
				                  " remainder (" + dividend + " - " + accumulator +
				                  ") or " + reminder);
				Console.WriteLine();
			}
			else
			{
				reminder = 0;
				
				Console.WriteLine(" So " + dividend +
				                  " divided by " + divisor +
				                  " using the Egyptian method is \n " + result +
				                  " remainder " + reminder);
				Console.WriteLine();
			}
		}
	}
}
