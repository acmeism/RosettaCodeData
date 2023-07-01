using System;
using System.Linq;

public class Program
{
    public static void Main() {
        Console.WriteLine(CheckISBN13("978-1734314502"));
        Console.WriteLine(CheckISBN13("978-1734314509"));
        Console.WriteLine(CheckISBN13("978-1788399081"));
        Console.WriteLine(CheckISBN13("978-1788399083"));

        static bool CheckISBN13(string code) {
            code = code.Replace("-", "").Replace(" ", "");
            if (code.Length != 13) return false;
            int sum = 0;
            foreach (var (index, digit) in code.Select((digit, index) => (index, digit))) {
                if (char.IsDigit(digit)) sum += (digit - '0') * (index % 2 == 0 ? 1 : 3);
                else return false;
            }
            return sum % 10 == 0;
        }
    }
}
