    public static class Luhn
    {
        public static bool LuhnCheck(this string cardNumber)
        {
            return LuhnCheck(cardNumber.Select(c => c - '0').ToArray());
        }

        private static bool LuhnCheck(this int[] digits)
        {
            return GetCheckValue(digits) == 0;
        }

        private static int GetCheckValue(int[] digits)
        {
            return digits.Select((d, i) => i % 2 == digits.Length % 2 ? ((2 * d) % 10) + d / 5 : d).Sum() % 10;
        }
    }

    public static class TestProgram
    {
        public static void Main()
        {
            long[] testNumbers = {49927398716, 49927398717, 1234567812345678, 1234567812345670};
            foreach (var testNumber in testNumbers)
                Console.WriteLine("{0} is {1}valid", testNumber, testNumber.ToString().LuhnCheck() ? "" : "not ");
        }
    }
