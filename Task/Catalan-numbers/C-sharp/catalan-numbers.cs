namespace CatalanNumbers
{
    /// <summary>
    /// Class that holds all options.
    /// </summary>
    public class CatalanNumberGenerator
    {
        private static double Factorial(double n)
        {
            if (n == 0)
                return 1;

            return n * Factorial(n - 1);
        }

        public double FirstOption(double n)
        {
            const double topMultiplier = 2;
            return Factorial(topMultiplier * n) / (Factorial(n + 1) * Factorial(n));
        }

        public double SecondOption(double n)
        {
            if (n == 0)
            {
                return 1;
            }
            double sum = 0;
            double i = 0;
            for (; i <= (n - 1); i++)
            {
                sum += SecondOption(i) * SecondOption((n - 1) - i);
            }
            return sum;
        }

        public double ThirdOption(double n)
        {
            if (n == 0)
            {
                return 1;
            }
            return ((2 * (2 * n - 1)) / (n + 1)) * ThirdOption(n - 1);
        }
    }
}


// Program.cs
using System;
using System.Configuration;

// Main program
// Be sure to add the following to the App.config file and add a reference to System.Configuration:
// <?xml version="1.0" encoding="utf-8" ?>
// <configuration>
//  <appSettings>
//    <clear/>
//    <add key="MaxCatalanNumber" value="50"/>
//  </appSettings>
// </configuration>
namespace CatalanNumbers
{
    class Program
    {
        static void Main(string[] args)
        {
            CatalanNumberGenerator generator = new CatalanNumberGenerator();
            int i = 0;
            DateTime initial;
            DateTime final;
            TimeSpan ts;

            try
            {
                initial = DateTime.Now;
                for (; i <= Convert.ToInt32(ConfigurationManager.AppSettings["MaxCatalanNumber"]); i++)
                {
                    Console.WriteLine("CatalanNumber({0}):{1}", i, generator.FirstOption(i));
                }
                final = DateTime.Now;
                ts = final - initial;
                Console.WriteLine("It took {0}.{1} to execute\n", ts.Seconds, ts.Milliseconds);

                i = 0;
                initial = DateTime.Now;
                for (; i <= Convert.ToInt32(ConfigurationManager.AppSettings["MaxCatalanNumber"]); i++)
                {
                    Console.WriteLine("CatalanNumber({0}):{1}", i, generator.SecondOption(i));
                }
                final = DateTime.Now;
                ts = final - initial;
                Console.WriteLine("It took {0}.{1} to execute\n", ts.Seconds, ts.Milliseconds);

                i = 0;
                initial = DateTime.Now;
                for (; i <= Convert.ToInt32(ConfigurationManager.AppSettings["MaxCatalanNumber"]); i++)
                {
                    Console.WriteLine("CatalanNumber({0}):{1}", i, generator.ThirdOption(i));
                }
                final = DateTime.Now;
                ts = final - initial;
                Console.WriteLine("It took {0}.{1} to execute", ts.Seconds, ts.Milliseconds, ts.TotalMilliseconds);
                Console.ReadLine();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Stopped at index {0}:", i);
                Console.WriteLine(ex.Message);
                Console.ReadLine();
            }
        }
    }
}
