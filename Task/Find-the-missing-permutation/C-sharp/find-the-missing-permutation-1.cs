using System;
using System.Collections.Generic;

namespace MissingPermutation
{
    class Program
    {
        static void Main()
        {
            string[] given = new string[] { "ABCD", "CABD", "ACDB", "DACB",
                                            "BCDA", "ACBD", "ADCB", "CDAB",
                                            "DABC", "BCAD", "CADB", "CDBA",
                                            "CBAD", "ABDC", "ADBC", "BDCA",
                                            "DCBA", "BACD", "BADC", "BDAC",
                                            "CBDA", "DBCA", "DCAB" };

            List<string> result = new List<string>();
            permuteString(ref result, "", "ABCD");

            foreach (string a in result)
                if (Array.IndexOf(given, a) == -1)
                    Console.WriteLine(a + " is a missing Permutation");
        }

        public static void permuteString(ref List<string> result, string beginningString, string endingString)
        {
            if (endingString.Length <= 1)
            {
                result.Add(beginningString + endingString);
            }
            else
            {
                for (int i = 0; i < endingString.Length; i++)
                {
                    string newString = endingString.Substring(0, i) + endingString.Substring(i + 1);
                    permuteString(ref result, beginningString + (endingString.ToCharArray())[i], newString);
                }
            }
        }
    }
}
