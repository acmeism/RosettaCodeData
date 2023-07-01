using System;
using System.Linq;
using System.Text.RegularExpressions;

namespace ValidateIsin
{
    public static class IsinValidator
    {
        public static bool IsValidIsin(string isin) =>
            IsinRegex.IsMatch(isin) && LuhnTest(Digitize(isin));

        private static readonly Regex IsinRegex =
            new Regex("^[A-Z]{2}[A-Z0-9]{9}\\d$", RegexOptions.Compiled);

        private static string Digitize(string isin) =>
            string.Join("", isin.Select(c => $"{DigitValue(c)}"));

        private static bool LuhnTest(string number) =>
            number.Reverse().Select(DigitValue).Select(Summand).Sum() % 10 == 0;

        private static int Summand(int digit, int i) =>
            digit + (i % 2) * (digit - digit / 5 * 9);

        private static int DigitValue(char c) =>
            c >= '0' && c <= '9'
                ? c - '0'
                : c - 'A' + 10;
   }
	
   public class Program
   {
        public static void Main()
        {
            string[] isins =
            {
                "US0378331005",
                "US0373831005",
                "U50378331005",
                "US03378331005",
                "AU0000XVGZA3",
                "AU0000VXGZA3",
                "FR0000988040"
            };

            foreach (string isin in isins) {
                string validOrNot = IsinValidator.IsValidIsin(isin) ? "valid" : "not valid";
                Console.WriteLine($"{isin} is {validOrNot}");
            }
        }
    }
}
