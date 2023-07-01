using System;
using System.Collections.Generic;

namespace prog
{
	class MainClass
	{	
		const int n_iter = 10;
		static int[] f = { 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0 };
		
		public static void Main (string[] args)
		{
			for( int i=0; i<f.Length; i++ )
				Console.Write( f[i]==0 ? "-" : "#" );
			Console.WriteLine("");			
			
			int[] g = new int[f.Length];
			for( int n=n_iter; n!=0; n-- )
			{
				for( int i=1; i<f.Length-1; i++ )
				{
					if ( (f[i-1] ^ f[i+1]) == 1 ) g[i] = f[i];
					else if ( f[i] == 0 && (f[i-1] & f[i+1]) == 1 ) g[i] = 1;
					else g[i] = 0;
				}
				g[0] = ( (f[0] & f[1]) == 1 ) ? 1 : 0;
				g[g.Length-1] = ( (f[f.Length-1] & f[f.Length-2]) == 1 ) ? 1 : 0;
				
				int[] tmp = f;
				f = g;
				g = tmp;
				
				for( int i=0; i<f.Length; i++ )
					Console.Write( f[i]==0 ? "-" : "#" );
				Console.WriteLine("");
			}			
		}
	}
}
