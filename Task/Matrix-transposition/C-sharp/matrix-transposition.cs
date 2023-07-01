using System;
using System.Text;

namespace prog
{
	class MainClass
	{						
		public static void Main (string[] args)
		{
			double[,] m = { {1,2,3},{4,5,6},{7,8,9} };
			
			double[,] t = Transpose( m );	
			
			for( int i=0; i<t.GetLength(0); i++ )
			{
				for( int j=0; j<t.GetLength(1); j++ )		
					Console.Write( t[i,j] + "  " );
				Console.WriteLine("");
			}
		}
		
		public static double[,] Transpose( double[,] m )
		{
			double[,] t = new double[m.GetLength(1),m.GetLength(0)];
			for( int i=0; i<m.GetLength(0); i++ )
				for( int j=0; j<m.GetLength(1); j++ )
					t[j,i] = m[i,j];			
			
			return t;
		}
	}
}
