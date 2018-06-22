namespace RosettaCode.GenerateLowerCaseASCIIAlphabet
{
    using System;
    using System.Collections.Generic;

    internal class Program
    {
        private static IEnumerable<char> Alphabet
        {
            get
            {
                for (var character = 'a'; character <= 'z'; character++)
                {
                    yield return character;
                }
            }
        }

        private static void Main()
        {
            Console.WriteLine(string.Join(string.Empty, Alphabet));
        }
    }
}
