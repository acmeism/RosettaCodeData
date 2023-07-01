using System;
using System.Text;
using System.Collections.Generic;

namespace BestShuffle_RC
{
    public class ShuffledString
    {
        private string original;
        private StringBuilder shuffled;
        private int ignoredChars;

        public string Original
        {
            get { return original; }
        }

        public string Shuffled
        {
            get { return shuffled.ToString(); }
        }

        public int Ignored
        {
            get { return ignoredChars; }
        }

        private void Swap(int pos1, int pos2)
        {
            char temp = shuffled[pos1];
            shuffled[pos1] = shuffled[pos2];
            shuffled[pos2] = temp;
        }

        //Determine if a swap between these two would put a letter in a "bad" place
        //If true, a swap is OK.
        private bool TrySwap(int pos1, int pos2)
        {
            if (original[pos1] == shuffled[pos2] || original[pos2] == shuffled[pos1])
                return false;
            else
                return true;
        }

        //Constructor carries out calls Shuffle function.
        public ShuffledString(string word)
        {
            original = word;
            shuffled = new StringBuilder(word);
            Shuffle();
            DetectIgnores();
        }

        //Does the hard work of shuffling the string.
        private void Shuffle()
        {
            int length = original.Length;
            int swaps;
            Random rand = new Random();
            List<int> used = new List<int>();

            for (int i = 0; i < length; i++)
            {
                swaps = 0;
                while(used.Count <= length - i)//Until all possibilities have been tried
                {
                    int j = rand.Next(i, length - 1);
                    //If swapping would make a difference, and wouldn't put a letter in a "bad" place,
                    //and hasn't already been tried, then swap
                    if (original[i] != original[j] && TrySwap(i, j) && !used.Contains(j))
                    {
                        Swap(i, j);
                        swaps++;
                        break;
                    }
                    else
                        used.Add(j);//If swapping doesn't work, "blacklist" the index
                }
                if (swaps == 0)
                {
                    //If a letter was ignored (no swap was found), look backward for another change to make
                    for (int k = i; k >= 0; k--)
                    {
                        if (TrySwap(i, k))
                            Swap(i, k);
                    }
                }
                //Clear the used indeces
                used.Clear();
            }
        }

        //Count how many letters are still in their original places.
        private void DetectIgnores()
        {
            int ignores = 0;
            for (int i = 0; i < original.Length; i++)
            {
                if (original[i] == shuffled[i])
                    ignores++;
            }

            ignoredChars = ignores;
        }

        //To allow easy conversion of strings.
        public static implicit operator ShuffledString(string convert)
        {
            return new ShuffledString(convert);
        }
    }

    public class Program
    {
        public static void Main(string[] args)
        {
            ShuffledString[] words = { "abracadabra", "seesaw", "elk", "grrrrrr", "up", "a" };

            foreach(ShuffledString word in words)
                Console.WriteLine("{0}, {1}, ({2})", word.Original, word.Shuffled, word.Ignored);

            Console.ReadKey();
        }
    }
}
