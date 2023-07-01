using System;

namespace BullsnCows
{
    class Program
    {

        static void Main(string[] args)
        {
            int[] nums = new int[] { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
            KnuthShuffle<int>(ref nums);
            int[] chosenNum = new int[4];
            Array.Copy(nums, chosenNum, 4);

            Console.WriteLine("Your Guess ?");
            while (!game(Console.ReadLine(), chosenNum))
            {
                Console.WriteLine("Your next Guess ?");
            }

            Console.ReadKey();
        }

        public static void KnuthShuffle<T>(ref T[] array)
        {
            System.Random random = new System.Random();
            for (int i = 0; i < array.Length; i++)
            {
                int j = random.Next(array.Length);
                T temp = array[i]; array[i] = array[j]; array[j] = temp;
            }
        }

        public static bool game(string guess, int[] num)
        {
            char[] guessed = guess.ToCharArray();
            int bullsCount = 0, cowsCount = 0;

            if (guessed.Length != 4)
            {
                Console.WriteLine("Not a valid guess.");
                return false;
            }

            for (int i = 0; i < 4; i++)
            {
                int curguess = (int) char.GetNumericValue(guessed[i]);
                if (curguess < 1 || curguess > 9)
                {
                    Console.WriteLine("Digit must be ge greater 0 and lower 10.");
                    return false;
                }
                if (curguess == num[i])
                {
                    bullsCount++;
                }
                else
                {
                    for (int j = 0; j < 4; j++)
                    {
                        if (curguess == num[j])
                            cowsCount++;
                    }
                }
            }

            if (bullsCount == 4)
            {
                Console.WriteLine("Congratulations! You have won!");
                return true;
            }
            else
            {
                Console.WriteLine("Your Score is {0} bulls and {1} cows", bullsCount, cowsCount);
                return false;
            }
        }
    }
}
