using System;

namespace Angle_difference_between_two_bearings
{
	class Program
	{
		public static void Main(string[] args)
		{
			Console.WriteLine();
			Console.WriteLine("Hello World!");
			Console.WriteLine();
			
			// Calculate standard test cases
			Console.WriteLine(Delta_Bearing( 20M,45));
			Console.WriteLine(Delta_Bearing(-45M,45M));
			Console.WriteLine(Delta_Bearing(-85M,90M));
			Console.WriteLine(Delta_Bearing(-95M,90M));
			Console.WriteLine(Delta_Bearing(-45M,125M));
			Console.WriteLine(Delta_Bearing(-45M,145M));
			Console.WriteLine(Delta_Bearing( 29.4803M,-88.6381M));
			Console.WriteLine(Delta_Bearing(-78.3251M, -159.036M));
			
			// Calculate optional test cases
			Console.WriteLine(Delta_Bearing(-70099.74233810938M,   29840.67437876723M));
			Console.WriteLine(Delta_Bearing(-165313.6666297357M,   33693.9894517456M));
			Console.WriteLine(Delta_Bearing( 1174.8380510598456M, -154146.66490124757M));
			Console.WriteLine(Delta_Bearing( 60175.77306795546M,   42213.07192354373M));
			
			Console.WriteLine();
			Console.Write("Press any key to continue . . . ");
			Console.ReadKey(true);
		}
		
		static decimal Delta_Bearing(decimal b1, decimal b2)
		{
			/*
			 * Optimal solution
			 *
			decimal d = 0;
			
			d = (b2-b1)%360;
			
			if(d>180)
				d -= 360;
			else if(d<-180)
				d += 360;
			
			return d;
			 *
			 *
			 */
			
			
			//
			//
			//
			decimal d = 0;
			
			// Convert bearing to W.C.B
			if(b1<0)
				b1 += 360;
			if(b2<0)
				b2 += 360;
			
			///Calculate delta bearing
			//and
			//Convert result value to Q.B.
			d = (b2 - b1)%360;
			
			if(d>180)
				d -= 360;
			else if(d<-180)
				d += 360;
			
			return d;
			
			//
			//
			//
		}
	}
}
