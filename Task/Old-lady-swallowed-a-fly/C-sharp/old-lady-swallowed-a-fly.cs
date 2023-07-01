using System;

namespace OldLady
{
    internal class Program
    {
        private const string reason = "She swallowed the {0} to catch the {1}";
        private static readonly string[] creatures = {"fly", "spider", "bird", "cat", "dog", "goat", "cow", "horse"};

        private static readonly string[] comments =
        {
            "I don't know why she swallowed that fly.\nPerhaps she'll die\n",
            "That wiggled and jiggled and tickled inside her",
            "How absurd, to swallow a bird",
            "Imagine that. She swallowed a cat",
            "What a hog to swallow a dog",
            "She just opened her throat and swallowed that goat",
            "I don't know how she swallowed that cow",
            "She's dead of course"
        };

        private static void Main()
        {
            int max = creatures.Length;
            for (int i = 0; i < max; i++)
            {
                Console.WriteLine("There was an old lady who swallowed a {0}", creatures[i]);
                Console.WriteLine(comments[i]);
                for (int j = i; j > 0 && i < max - 1; j--)
                {
                    Console.WriteLine(reason, creatures[j], creatures[j - 1]);
                    if (j == 1)
                    {
                        Console.WriteLine(comments[j - 1]);
                    }
                }
            }
            Console.Read();
        }
    }
}
