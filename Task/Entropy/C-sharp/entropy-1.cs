using System;
using System.Collections.Generic;
namespace Entropy
{
	class Program
	{
		public static double logtwo(double num)
		{
			return Math.Log(num)/Math.Log(2);
		}
		public static void Main(string[] args)
		{
		label1:
			string input = Console.ReadLine();
			double infoC=0;
			Dictionary<char,double> table = new Dictionary<char, double>();

			
			foreach (char c in input)
			{
				if (table.ContainsKey(c))
					table[c]++;
				    else
				    	table.Add(c,1);
	
			}
			double freq;
			foreach (KeyValuePair<char,double> letter in table)
			{
				freq=letter.Value/input.Length;
				infoC+=freq*logtwo(freq);
			}
			infoC*=-1;
			Console.WriteLine("The Entropy of {0} is {1}",input,infoC);
			goto label1;
		
		}
	}
}
