using System;

namespace Pyramid_of_Numbers
{
        class Program
	{
		public static void Main(string[] args)
		{
			// Set console properties
			Console.Title = " Pyramid of Numbers  /  Pascal's triangle Puzzle";
			Console.SetBufferSize(80,1000);
			Console.SetWindowSize(80,60);
			Console.ForegroundColor = ConsoleColor.Green;

			
			// Main Program Loop
			ConsoleKeyInfo k = new ConsoleKeyInfo('Y', ConsoleKey.Y,true,true,true);
			while (k.Key == ConsoleKey.Y)
			{
				Console.Clear();
				
				Console.WriteLine("----------------------------------------------");
				Console.WriteLine(" Pyramid of Numbers / Pascal's triangle Puzzle");
				Console.WriteLine("----------------------------------------------");
				Console.WriteLine();

				
				
				//
				// Declare new Pyramid array
				//
				int r = 5;// Number of rows
				int [,] Pyramid = new int[r,r];
				
				// Set initial Pyramid values
				for (int i = 0; i < r; i++)
				{
					for(int j = 0; j < r; j++)
					{
						Pyramid[i,j] = 0;
					}
				}
				// Show info on created array
				Console.WriteLine(" Pyramid has " + r + " rows");
				Console.WriteLine("--------------------------------------------");
				
				// Enter Pyramid values
				for(int i = 0; i <= r-1; i++)
				{
					Console.WriteLine(" Enter " + (i+1).ToString() + ". row values:");
					Console.WriteLine("--------------------------------------------");
					
					for(int j = 0; j < i+1; j++)
					{
						Console.Write(" " + (j+1).ToString() + ". value = ");
						int v = int.Parse(Console.ReadLine());
						
						Pyramid[i,j] = v;
					}
					Console.WriteLine("--------------------------------------------");
				}
				
				//
				// Show initial Pyramid values
				//
				Console.WriteLine();
				Console.WriteLine(" Initial Pyramid Values ");
				Console.WriteLine();
				
				// Show Pyramid values
				for(int i = 0; i <= r-1; i++)
				{
					for(int j = 0; j < i+1; j++)
					{
						Console.Write("{0,4}",Pyramid[i,j]);
					}
					Console.WriteLine();
				}
				Console.WriteLine("--------------------------------------------");
				
				// Find solution
				Solve_Pyramid(Pyramid);
				
				Console.WriteLine();
				Console.Write(" Start new calculation <Y/N>  . . . ");
				k = Console.ReadKey(true);
			}
		}
		
                //
                // Solve Function
                //
		public static void Solve_Pyramid(int [,] Pyramid)
		{
			int r = 5; // Number of rows
			
			// Calculate Y
			int a = Pyramid[r-1,1];
			int b = Pyramid[r-1,3];
			int c = Pyramid[0,0];
			
			int y =  (c - (4*a) - (4*b))/7;
			Pyramid[r-1,2] = y;
			
			
			// Create copy of Pyramid
			int [,] Pyramid_Copy = new int[r,r];
			Array.Copy(Pyramid,Pyramid_Copy,r*r);
			
			int n = 0; // solution counter
			for(int x = 0; x < y + 1; x++)
			{
				for(int z = 0; z < y + 1; z++)
				{
					if( (x+z) == y)
					{
						Pyramid[r-1,0]   = x;
						Pyramid[r-1,r-1] = z;
						
						// Recalculate Pyramid values
						for(int i = r-1; i > 0; i--)
						{
							for(int j = 0; j < i; j++)
							{
								Pyramid[i-1,j] = Pyramid[i,j]+Pyramid[i,j+1];
							}
						}
						
						
						// Compare Pyramid values
						bool solved = true;
						for(int i = 0; i < r-1; i++)
						{
							for(int j = 0; j < i+1; j++)
							{
								if(Pyramid_Copy[i,j]>0)
								{
									if(Pyramid[i,j] != Pyramid_Copy[i,j])
									{
										solved = false;
										i = r;
										break;
									}
								}
							}
						}
						
						if(solved)
						{
							n++;
							Console.WriteLine();
							Console.WriteLine(" Solved Pyramid Values no." + n);
							Console.WriteLine();
							
							// Show Pyramid values
							for(int i = 0; i <= r-1; i++)
							{
								for(int j = 0; j < i+1; j++)
								{
									Console.Write("{0,4}",Pyramid[i,j]);
								}
								Console.WriteLine();
							}
							Console.WriteLine();
							Console.WriteLine(" X = " + Pyramid[r-1,0] + "   " +
							                  " Y = " + Pyramid[r-1,2] + "   " +
							                  " Z = " + Pyramid[r-1,4]);
							Console.WriteLine();
							Console.WriteLine("--------------------------------------------");
						}
						
						Array.Copy(Pyramid_Copy,Pyramid,r*r);
					}
				}
			}
			
			if(n == 0)
			{
				Console.WriteLine();
				Console.WriteLine(" Pyramid has no solution ");
				Console.WriteLine();
			}
		}
		
	}
}
