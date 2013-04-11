using System;

namespace prog
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			int q = 929;
			if ( !isPrime(q) ) return;
			int r = q;
			while( r > 0 )
				r <<= 1;
			int d = 2 * q + 1;
			do
			{
				int i = 1;
				for( int p=r; p!=0; p<<=1 )
				{
					i = (i*i) % d;
					if (p < 0) i *= 2;
					if (i > d) i -= d;
				}
				if (i != 1) d += 2 * q; else break;				
			}
			while(true);
			
			Console.WriteLine("2^"+q+"-1 = 0 (mod "+d+")");
		}
		
		static bool isPrime(int n)
		{
			if ( n % 2 == 0 ) return n == 2;
			if ( n % 3 == 0 ) return n == 3;
			int d = 5;
			while( d*d <= n )
			{
				if ( n % d == 0 ) return false;
				d += 2;
				if ( n % d == 0 ) return false;
				d += 4;
			}
			return true;
		}
	}
}
