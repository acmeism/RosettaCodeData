using System;
using System.Collections.Generic;

namespace example
{
    class Program
    {
        static void Main(string[] args)
        {
            var strings = new string[] { "abcd", "123456789", "abcdef", "1234567" };
            compareAndReportStringsLength(strings);
        }

        private static void compareAndReportStringsLength(string[] strings)
        {
            if (strings.Length > 0)
            {
                char Q = '"';
                string hasLength = " has length ";
                string predicateMax = " and is the longest string";
                string predicateMin = " and is the shortest string";
                string predicateAve = " and is neither the longest nor the shortest string";
                string predicate;

                (int, int)[] li = new (int, int)[strings.Length];
                for (int i = 0; i < strings.Length; i++)
                    li[i] = (strings[i].Length, i);
                Array.Sort(li, ((int, int) a, (int, int) b) => b.Item1 - a.Item1);
                int maxLength = li[0].Item1;
                int minLength = li[strings.Length - 1].Item1;

                for (int i = 0; i < strings.Length; i++)
                {
                    int length = li[i].Item1;
                    string str = strings[li[i].Item2];
                    if (length == maxLength)
                        predicate = predicateMax;
                    else if (length == minLength)
                        predicate = predicateMin;
                    else
                        predicate = predicateAve;
                    Console.WriteLine(Q + str + Q + hasLength + length + predicate);
                }
            }
        }

    }
}
