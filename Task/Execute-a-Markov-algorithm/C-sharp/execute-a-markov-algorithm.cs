using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class Markov
{
    /// <summary>
    /// Take a ruleset and return a function which takes a string to which the rules
    /// should be applied.
    /// </summary>
    /// <param name="ruleSet">String containing the rules</param>
    /// <returns>A function that takes a string and applies the rules</returns>
    public static Func<string, string> CreateMarkovProcessor(string ruleSet)
    {
        // Convert a ruleset string into a dictionary
        Dictionary<string, string> MakeRuleMap(string ruleset)
        {
            return ruleset.Split('\n')
                .Where(e => !e.StartsWith("#"))
                .Select(e => e.Split(new[] { " -> " }, StringSplitOptions.None))
                .ToDictionary(e => e[0], e => e[1]);
        }

        // Split a string at an index
        Tuple<string, string> SplitAt(string s, int i)
        {
            return new Tuple<string, string>(s.Substring(0, i), s.Substring(i));
        }

        // Strip a leading number of chars from a string.
        string StripLeading(string s, string strip)
        {
            return s.Substring(strip.Length);
        }

        // Replace the substring in the string.
        string Replace(string s, string find, string rep)
        {
            string result = s;
            if (s.IndexOf(find) >= 0)
            {
                var a = SplitAt(s, s.IndexOf(find));
                result = a.Item1 + rep + StripLeading(a.Item2, find);
            }
            return result;
        }

        // Recursively apply the ruleset to the string.
        string Parse(Dictionary<string, string> rules, string s)
        {
            string o = s;
            foreach (var rule in rules)
            {
                string k = rule.Key;
                string v = rule.Value;

                if (v.StartsWith("."))
                {
                    s = Replace(s, k, StripLeading(v, "."));
                    break;
                }
                else
                {
                    s = Replace(s, k, v);
                    if (s != o) { break; }
                }
            }
            return o == s ? s : Parse(rules, s);
        }

        var ruleMap = MakeRuleMap(ruleSet);
        return str => Parse(ruleMap, str);
    }

    public static void Main()
    {
        string ruleset1 = @"# This rules file is extracted from Wikipedia:
# http://en.wikipedia.org/wiki/Markov_Algorithm
A -> apple
B -> bag
S -> shop
T -> the
the shop -> my brother
a never used -> .terminating rule";

        string ruleset2 = @"# Slightly modified from the rules on Wikipedia
A -> apple
B -> bag
S -> .shop
T -> the
the shop -> my brother
a never used -> .terminating rule";

        string ruleset3 = @"# BNF Syntax testing rules
A -> apple
WWWW -> with
Bgage -> ->.*
B -> bag
->.* -> money
W -> WW
S -> .shop
T -> the
the shop -> my brother
a never used -> .terminating rule";

        string ruleset4 = @"### Unary Multiplication Engine, for testing Markov Algorithm implementations
### By Donal Fellows.
# Unary addition engine
_+1 -> _1+
1+1 -> 11+
# Pass for converting from the splitting of multiplication into ordinary
# addition
1! -> !1
,! -> !+
_! -> _
# Unary multiplication by duplicating left side, right side times
1*1 -> x,@y
1x -> xX
X, -> 1,1
X1 -> 1X
_x -> _X
,x -> ,X
y1 -> 1y
y_ -> _
# Next phase of applying
1@1 -> x,@y
1@_ -> @_
,@_ -> !_
++ -> +
# Termination cleanup for addition
_1 -> 1
1+_ -> 1
_+_ -> ";

        string ruleset5 = @"# Turing machine: three-state busy beaver
#
# state A, symbol 0 => write 1, move right, new state B
A0 -> 1B
# state A, symbol 1 => write 1, move left, new state C
0A1 -> C01
1A1 -> C11
# state B, symbol 0 => write 1, move left, new state A
0B0 -> A01
1B0 -> A11
# state B, symbol 1 => write 1, move right, new state B
B1 -> 1B
# state C, symbol 0 => write 1, move left, new state B
0C0 -> B01
1C0 -> B11
# state C, symbol 1 => write 1, move left, halt
0C1 -> H01
1C1 -> H11";

        Console.WriteLine(CreateMarkovProcessor(ruleset1)("I bought a B of As from T S."));
        Console.WriteLine(CreateMarkovProcessor(ruleset2)("I bought a B of As from T S."));
        Console.WriteLine(CreateMarkovProcessor(ruleset3)("I bought a B of As W my Bgage from T S."));
        Console.WriteLine(CreateMarkovProcessor(ruleset4)("_1111*11111_"));
        Console.WriteLine(CreateMarkovProcessor(ruleset5)("000000A000000"));
    }
}
