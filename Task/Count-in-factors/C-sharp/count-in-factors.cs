using System;
using System.Collections.Generic;

namespace prog
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			for( int i=1; i<=22; i++ )
			{				
				List<int> f = Factorize(i);
				Console.Write( i + ":  " + f[0] );
				for( int j=1; j<f.Count; j++ )
				{
					Console.Write( " * " + f[j] );
				}
				Console.WriteLine();
			}
		}
		
		public static List<int> Factorize( int n )
		{
			List<int> l = new List<int>();
		
			if ( n == 1 )
			{
				l.Add(1);
			}
			else
			{
				int k = 2;
				while( n > 1 )
				{
					while( n % k == 0 )
					{
						l.Add( k );
						n /= k;
					}
					k++;
				}
			}			
			return l;
		}	
	}
}
