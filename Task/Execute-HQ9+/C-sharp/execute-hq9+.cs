using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void RunCode(string code)
    {
        int accumulator = 0;
        var opcodes = new Dictionary<char, Action>
        {
            {'H', () => Console.WriteLine("Hello, World!"))},
            {'Q', () => Console.WriteLine(code) },
            {'9', () => Console.WriteLine(Enumerable.Range(1,100).Reverse().Select(n => string.Format("{0} bottles of beer on the wall\n{0} bottles of beer\nTake one down, pass it around\n{1} bottles of beer on the wall\n", n, n-1)).Aggregate((a,b) => a + "\n" + b))},
            {'+', () => accumulator++ }
        }

        foreach(var c in code)
            opcodes[c]();
    }
}
