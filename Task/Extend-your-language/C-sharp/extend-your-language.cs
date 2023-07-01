using System;
using System.Reflection;

namespace Extend_your_language
{
	

	class Program
	{
		
		public static void Main(string[] args)
		{
			Console.WriteLine();
			Console.WriteLine("Hello World!");
			Console.WriteLine();
			
			int x = 0;
			int y = 0;
			
			for(x=0;x<2;x++)
			{
				for(y=0;y<2;y++)
				{
					
					CONDITIONS( (x==0) , (y==0) ).
						IF2  ("METHOD1").
						ELSE1("METHOD2").
						ELSE2("METHOD3").
						ELSE ("METHOD4");
					
				}
			}
			
			Console.WriteLine();
			Console.Write("Press any key to continue . . . ");
			Console.ReadKey(true);
		}
		
		
		
		
		public static void METHOD1()
		{
			Console.WriteLine("METHOD 1 executed - both are true");
		}
		
		public static void METHOD2()
		{
			Console.WriteLine("METHOD 2 executed - first is true");
		}
		
		public static void METHOD3()
		{
			Console.WriteLine("METHOD 3 executed - second is true");
		}
		
		public static void METHOD4()
		{
			Console.WriteLine("METHOD 4 executed - both are false");
		}
		
		
		static int CONDITIONS(bool condition1, bool condition2)
		{
			int c = 0;
			if(condition1 && condition2)
				c = 0;
			else if(condition1)
				c = 1;
			else if(condition2)
				c = 2;
			else
				c = 3;
			
			return c;
		}
	}
	
	
	public static class ExtensionMethods
	{

		public static int IF2(this int value, string method)
		{
			if(value == 0)
			{
				MethodInfo m = typeof(Program).GetMethod(method);
				m.Invoke(null,null);
			}
			
			return value;
		}
		
		public static int ELSE1(this int value, string method)
		{
			if(value == 1)
			{
				MethodInfo m = typeof(Program).GetMethod(method);
				m.Invoke(null,null);
			}
			
			return value;
		}
		
		public static int ELSE2(this int value, string method)
		{
			if(value == 2)
			{
				MethodInfo m = typeof(Program).GetMethod(method);
				m.Invoke(null,null);
			}
			
			return value;
		}
		
		public static void ELSE(this int value, string method)
		{
			if(value == 3)
			{
				MethodInfo m = typeof(Program).GetMethod(method);
				m.Invoke(null,null);
			}
		}
		
	}
}
