using System;

namespace prog
{
	class MainClass
	{
		const float T0 = 100f;
		const float TR = 20f;
		const float k = 0.07f;
		readonly static float[] delta_t = {2.0f,5.0f,10.0f};
		const int n = 100;
		
		public delegate float func(float t);
		static float NewtonCooling(float t)
		{
			return -k * (t-TR);			
		}
		
		public static void Main (string[] args)
		{
			func f = new func(NewtonCooling);
			for(int i=0; i<delta_t.Length; i++)
			{
				Console.WriteLine("delta_t = " + delta_t[i]);
				Euler(f,T0,n,delta_t[i]);
			}
		}
				
		public static void Euler(func f, float y, int n, float h)
		{
			for(float x=0; x<=n; x+=h)
			{
				Console.WriteLine("\t" + x + "\t" + y);
				y += h * f(y);	
			}
		}
	}
}
