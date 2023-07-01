using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BullsAndCows
{
    class Program
    {
        const int ANSWER_SIZE = 4;

        static IEnumerable<string> Permutations(int size)
        {
            if (size > 0)
            {
                foreach (string s in Permutations(size - 1))
                    foreach (char n in "123456789")
                        if (!s.Contains(n))
                            yield return s + n;
            }
            else
                yield return "";
        }

        static IEnumerable<T> Shuffle<T>(IEnumerable<T> source)
        {
            Random random = new Random();
            List<T> list = source.ToList();
            while (list.Count > 0)
            {
                int ix = random.Next(list.Count);
                yield return list[ix];
                list.RemoveAt(ix);
            }
        }

        static bool ReadBullsCows(out int bulls, out int cows)
        {
            string[] input = Console.ReadLine().Split(',').ToArray();
            bulls = cows = 0;
            if (input.Length < 2)
                return false;
            else
                return int.TryParse(input[0], out bulls)
                    && int.TryParse(input[1], out cows);
        }

        static void Main(string[] args)
        {
            Console.WriteLine("Bulls and Cows");
            Console.WriteLine("==============");
            Console.WriteLine();
            List<string> answers = Shuffle(Permutations(ANSWER_SIZE)).ToList();
            while (answers.Count > 1)
            {
                string guess = answers[0];
                Console.Write("My guess is {0}. How many bulls, cows? ", guess);
                int bulls, cows;
                if (!ReadBullsCows(out bulls, out cows))
                    Console.WriteLine("Sorry, I didn't understand that. Please try again.");
                else
                    for (int ans = answers.Count - 1; ans >= 0; ans--)
                    {
                        int tb = 0, tc = 0;
                        for (int ix = 0; ix < ANSWER_SIZE; ix++)
                            if (answers[ans][ix] == guess[ix])
                                tb++;
                            else if (answers[ans].Contains(guess[ix]))
                                tc++;
                        if ((tb != bulls) || (tc != cows))
                            answers.RemoveAt(ans);
                    }
            }
            if (answers.Count == 1)
                Console.WriteLine("Hooray! The answer is {0}!", answers[0]);
            else
                Console.WriteLine("No possible answer fits the scores you gave.");
        }
    }
}
