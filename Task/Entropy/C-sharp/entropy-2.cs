using System;
namespace Entropy
{
	 class Program
	{
		public static double logtwo(double num)
		{
			return Math.Log(num)/Math.Log(2);
		}
		static double Contain(string x,char k)
		{
			double count=0;
			foreach (char Y in x)
			{
				if(Y.Equals(k))
					count++;
			}
			return count;
		}
		public static void Main(string[] args)
		{
		label1:
			string input = Console.ReadLine();
			double infoC=0;
			double freq;
			string k="";
			foreach (char c1 in input)
			{
				if (!(k.Contains(c1.ToString())))
					k+=c1;
			}
			foreach (char c in k)
			{
				freq=Contain(input,c)/(double)input.Length;
				infoC+=freq*logtwo(freq);
			}
			infoC/=-1;
			Console.WriteLine("The Entropy of {0} is {1}",input,infoC);
			goto label1;

		}
	}
}
