internal class Program
{
    private static void Main(string[] args)
    {
        long number = 1;
        int displayMax = 50;
        long highBar = 10_000_000;

        List<long> cyclops = [];
        int cyclopsCount = 0;
        long firstCyclopsOverHighBar = 0;
        int firstCyclopsOverHighBarIndex = 0;
        List<long> primeCyclops = [];
        int primeCyclopsCount = 0;
        long firstPrimeCyclopsOverHighBar = 0;
        int firstPrimeCyclopsOverHighBarIndex = 0;
        List<long> primeBlindCyclops = [];
        int primeBlindCyclopsCount = 0;
        long firstPrimeBlindCyclopsOverHighBar = 0;
        int firstPrimeBlindCyclopsOverHighBarIndex = 0;
        List<long> primePalindroneCyclops = [];
        int primePalindromCyclopsCount = 0;
        long firstPrimePalindromeCyclopsOverHighBar = 0;
        int firstPrimePalindromeCyclopsOverHighBarIndex = 0;

        while (firstCyclopsOverHighBarIndex == 0 || cyclopsCount < displayMax
            || firstPrimeCyclopsOverHighBarIndex == 0 || primeCyclopsCount < displayMax
            || firstPrimeBlindCyclopsOverHighBarIndex == 0 || primeBlindCyclopsCount < displayMax
            || firstPrimePalindromeCyclopsOverHighBarIndex == 0 || primePalindromCyclopsCount < displayMax)
        {
            if (IsCyclopsNumber(number))
            {
                cyclopsCount++;

                if (cyclops.Count < displayMax)
                {
                    cyclops.Add(number);
                }

                if (firstCyclopsOverHighBarIndex == 0 && number > highBar)
                {
                    firstCyclopsOverHighBar = number;
                    firstCyclopsOverHighBarIndex = cyclopsCount;
                }

                if (IsPrime(number))
                {
                    primeCyclopsCount++;

                    if (firstPrimeCyclopsOverHighBarIndex == 0 && number > highBar)
                    {
                        firstPrimeCyclopsOverHighBar = number;
                        firstPrimeCyclopsOverHighBarIndex = primeCyclopsCount;
                    }

                    if (primeCyclops.Count < displayMax)
                    {
                        primeCyclops.Add(number);
                    }

                    if (IsPrime(BlindCyclopsNumber(number)))
                    {
                        primeBlindCyclopsCount++;

                        if (firstPrimeBlindCyclopsOverHighBarIndex == 0 && number > highBar)
                        {
                            firstPrimeBlindCyclopsOverHighBar = number;
                            firstPrimeBlindCyclopsOverHighBarIndex = primeBlindCyclopsCount;
                        }

                        if (primeBlindCyclops.Count < displayMax)
                        {
                            primeBlindCyclops.Add(number);
                        }
                    }

                    if (IsPalindrome(number.ToString()))
                    {
                        primePalindromCyclopsCount++;

                        if (firstPrimePalindromeCyclopsOverHighBarIndex == 0 && number > highBar)
                        {
                            firstPrimePalindromeCyclopsOverHighBar = number;
                            firstPrimePalindromeCyclopsOverHighBarIndex = primePalindromCyclopsCount;
                        }

                        if (primePalindroneCyclops.Count < displayMax)
                        {
                            primePalindroneCyclops.Add(number);
                        }
                    }
                }
            }

            number++;
        }

        DisplayNumberSequence(cyclops, $"First {displayMax} Cyclops Numbers", highBar, firstCyclopsOverHighBarIndex, firstCyclopsOverHighBar);
        DisplayNumberSequence(primeCyclops, $"First {displayMax} Prime Cyclops Numbers", highBar, firstPrimeCyclopsOverHighBarIndex, firstPrimeCyclopsOverHighBar);
        DisplayNumberSequence(primeBlindCyclops, $"First {displayMax} Blind Prime Cyclops Numbers", highBar, firstPrimeBlindCyclopsOverHighBarIndex, firstPrimeBlindCyclopsOverHighBar);
        DisplayNumberSequence(primePalindroneCyclops, $"First {displayMax} Palidrome Cyclops Numbers", highBar, firstPrimePalindromeCyclopsOverHighBarIndex, firstPrimePalindromeCyclopsOverHighBar);
    }

    private static void DisplayNumberSequence(List<long> numbers, string title,
        long highBar, long firstIndexOverHighBar, long firstOverHighBar)
    {
        Console.WriteLine(title);

        for (int i = 0; i < numbers.Count; i++)
        {
            Console.Write($"{numbers[i],-7} ");

            if ((i + 1) % 10 == 0)
            {
                Console.WriteLine();
            }
        }

        Console.WriteLine($"The first such number > {highBar} is the {firstIndexOverHighBar}th: {firstOverHighBar}");
        Console.WriteLine();
    }

    private static bool IsCyclopsNumber(long number )
    {
        string numberAsString = number.ToString();
        int numberLength = numberAsString.Length;
        int middleDigit = numberLength / 2;

        if (numberLength > 1 && numberLength % 2 !=0 // the number has an odd number of digits greater than one
            && numberAsString.Count(c => c == '0') == 1 // there is only one zero
            && numberAsString[middleDigit] == '0') // Zero is the middle digit
        {
            return true;
        }
        return false;
    }

    private static bool IsPalindrome(string stringInput)
    {
        if (stringInput != null && stringInput.Length > 0)
        {
            var reversedString = new string(stringInput.ToCharArray().Reverse().ToArray());
            return stringInput == reversedString;
        }

        return false;
    }

    private static long BlindCyclopsNumber(long number)
    {
        string numberAsString = number.ToString();
        int numberLength = numberAsString.Length;
        int middleDigit = numberLength / 2;
        string blindNumber = string.Concat(numberAsString.AsSpan(0, middleDigit), numberAsString.AsSpan(middleDigit + 1, numberLength - (middleDigit + 1)));
        return long.Parse(blindNumber);
    }

    private static bool IsPrime(long number)
    {
        if (number < 2)
        {
            return false;
        }

        if (number % 2 == 0)
        {
            return number == 2;
        }

        if (number % 3 == 0)
        {
            return number == 3;
        }

        int delta = 2;
        long k = 5;

        while (k * k <= number)
        {
            if (number % k == 0)
            {
                return false;
            }

            k += delta;
            delta = 6 - delta;
        }

        return true;
    }
}
