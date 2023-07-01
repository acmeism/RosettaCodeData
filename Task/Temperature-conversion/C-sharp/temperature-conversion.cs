using System;

namespace TemperatureConversion
{
    class Program
    {
        static Func<double, double> ConvertKelvinToFahrenheit = x => (x * 1.8) - 459.67;
        static Func<double, double> ConvertKelvinToRankine = x => x * 1.8;
        static Func<double, double> ConvertKelvinToCelsius = x => x = 273.13;

        static void Main(string[] args)
        {
            Console.Write("Enter a Kelvin Temperature: ");
            string inputVal = Console.ReadLine();
            double kelvinTemp = 0f;

            if (double.TryParse(inputVal, out kelvinTemp))
            {
                Console.WriteLine(string.Format("Kelvin: {0}", kelvinTemp));
                Console.WriteLine(string.Format("Fahrenheit: {0}", ConvertKelvinToFahrenheit(kelvinTemp)));
                Console.WriteLine(string.Format("Rankine: {0}", ConvertKelvinToRankine(kelvinTemp)));
                Console.WriteLine(string.Format("Celsius: {0}", ConvertKelvinToCelsius(kelvinTemp)));
                Console.ReadKey();
            }
            else
            {
                Console.WriteLine("Invalid input value: " + inputVal);
            }
        }
    }
}
