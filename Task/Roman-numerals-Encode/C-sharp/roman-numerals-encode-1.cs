using System;
class Program
{
    static uint[] nums = { 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 };
    static string[] rum = { "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I" };

    static string ToRoman(uint number)
    {
        string value = "";
        for (int i = 0; i < nums.Length && number != 0; i++)
        {
            while (number >= nums[i])
            {
                number -= nums[i];
                value += rum[i];
            }
        }
        return value;
    }

    static void Main()
    {
        for (uint number = 1; number <= 1 << 10; number *= 2)
        {
            Console.WriteLine("{0} = {1}", number, ToRoman(number));
        }
    }
}
