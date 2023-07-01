namespace RosettaCode
{
    using System;

    public static class EvenOrOdd
    {
        public static bool IsEvenBitwise(this int number)
        {
            return (number & 1) == 0;
        }

        public static bool IsOddBitwise(this int number)
        {
            return (number & 1) != 0;
        }

        public static bool IsEvenRemainder(this int number)
        {
            int remainder;
            Math.DivRem(number, 2, out remainder);
            return remainder == 0;
        }

        public static bool IsOddRemainder(this int number)
        {
            int remainder;
            Math.DivRem(number, 2, out remainder);
            return remainder != 0;
        }

        public static bool IsEvenModulo(this int number)
        {
            return (number % 2) == 0;
        }

        public static bool IsOddModulo(this int number)
        {
            return (number % 2) != 0;
        }
    }
    public class Program
    {
        public static void Main()
        {
            int num = 26;               //Set this to any integer.
            if (num.IsEvenBitwise())    //Replace this with any even function.
            {
                Console.Write("Even");
            }
            else
            {
                Console.Write("Odd");
            }
            //Prints "Even".
            if (num.IsOddBitwise())    //Replace this with any odd function.
            {
                Console.Write("Odd");
            }
            else
            {
                Console.Write("Even");
            }
            //Prints "Even".
        }
    }
}
