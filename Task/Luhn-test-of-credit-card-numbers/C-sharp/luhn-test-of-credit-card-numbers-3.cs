using System;
namespace Luhn_Test
{
	public static class Extensions
	{
		public static string Reverse(this string s )
		{
		    char[] charArray = s.ToCharArray();
		    Array.Reverse( charArray );
		    return new string( charArray );
		}
	}
	class Program
	{
		public static bool Luhn(long x)
		{
			long s1=0;
			long s2=0;
			bool STATE=x%10!=0; // If it ends with zero, we want the order to be the other way around
			x=long.Parse(x.ToString().Reverse());
			while (x!=0)
			{
				s1+=STATE?x%10:0;
				s2+=STATE?0:((x%10)*2>9)?(((x%10)*2/10)+((x%10)*2)%10):((x%10)*2);
				STATE=!STATE; //Switch state
				x/=10; //Cut the last digit and continue
			}
			return ((s1+s2)%10==0); //Check if it ends with zero, if so, return true, otherwise,false.
		}
		public static void Main(string[] args)
		{
			long[] ks = {1234567812345670, 49927398717, 1234567812345678 ,1234567812345670 };
			foreach (long k in ks)
			{
			Console.WriteLine("{0} is {1} Valid.",k,Luhn(k)?"":"Not");	
			}
		Start:
			try {
			Console.WriteLine("Enter your credit:");
			long x=long.Parse(Console.ReadLine());
			Console.WriteLine("{0} Valid.",Luhn(x)?"":"Not");
			goto Start;
			}
			catch (FormatException)
			{
				goto Start;
			}			
		}
	}
}
