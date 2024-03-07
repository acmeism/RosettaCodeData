using System;

class ErdosNicolasNumbers
{
    static void Main(string[] args)
    {
        const int limit = 100_000_000;

        int[] divisorSum = new int[limit + 1];
        int[] divisorCount = new int[limit + 1];
        for (int i = 0; i <= limit; i++)
        {
            divisorSum[i] = 1;
            divisorCount[i] = 1;
        }

        for (int index = 2; index <= limit / 2; index++)
        {
            for (int number = 2 * index; number <= limit; number += index)
            {
                if (divisorSum[number] == number)
                {
                    Console.WriteLine($"{number,8} equals the sum of its first {divisorCount[number],3} divisors");
                }

                divisorSum[number] += index;
                divisorCount[number]++;
            }
        }
    }
}
