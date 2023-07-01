using System;
using System.Collections.Generic;
using System.Text;

namespace MoveToFront
{
    class Program
    {
        private static char[] symbolTable;
        private static void setSymbolTable()
        {
            symbolTable = "abcdefghijklmnopqrstuvwxyz".ToCharArray();
        }

        private static void moveToFront(int charIndex)
        {
            char toFront = symbolTable[charIndex];
            for (int j = charIndex; j > 0; j--)
            {
                symbolTable[j] = symbolTable[j - 1];
            }
            symbolTable[0] = toFront;
        }

        public static int[] Encode(string input)
        {
            setSymbolTable();
            var output = new List<int>();
            foreach (char c in input)
            {
                for (int i = 0; i < 26; i++)
                {
                    if (symbolTable[i] == c)
                    {
                        output.Add(i);
                        moveToFront(i);
                        break;
                    }
                }
            }
            return output.ToArray();
        }

        public static string Decode(int[] input)
        {
            setSymbolTable();
            var output = new StringBuilder(input.Length);
            foreach (int n in input)
            {
                output.Append(symbolTable[n]);
                moveToFront(n);
            }
            return output.ToString();
        }

        static void Main(string[] args)
        {
            string[] testInputs = new string[] { "broood", "bananaaa", "hiphophiphop" };
            int[] encoding;
            foreach (string s in testInputs)
            {
                Console.WriteLine($"Encoding for '{s}':");
                encoding = Encode(s);
                foreach (int i in encoding)
                {
                    Console.Write($"{i} ");
                }
                Console.WriteLine($"\nDecoding for '{s}':");
                Console.WriteLine($"{Decode(encoding)}\n");
            }
        }
    }
}
