using System;
using System.Collections.Generic;
using System.Linq;

public class EBNFParser
{
    // Token class equivalent
    private class Token
    {
        public object Value { get; set; }
        public bool IsSequence { get; set; }

        public Token(object value, bool isSequence)
        {
            Value = value;
            IsSequence = isSequence;
        }
    }

    // Sequence class equivalent to ArrayList with constructor
    private class Sequence : List<object>
    {
        public Sequence(params object[] items)
        {
            AddRange(items);
        }
    }

    private string src;
    private char ch;
    private int sdx;
    private Token token;
    private bool err = false;
    private List<string> idents = new List<string>();
    private List<int> ididx = new List<int>();
    private List<Sequence> productions = new List<Sequence>();
    private Sequence extras = new Sequence();
    private string[] results = { "pass", "fail" };

    private int BoolToInt(bool b)
    {
        return b ? 1 : 0;
    }

    private int Invalid(string msg)
    {
        err = true;
        Console.WriteLine(msg);
        sdx = src.Length; // set to eof
        return -1;
    }

    private void SkipSpaces()
    {
        while (sdx < src.Length)
        {
            ch = src[sdx];
            if (" \t\r\n".IndexOf(ch) == -1)
            {
                break;
            }
            sdx++;
        }
    }

    private void GetToken()
    {
        // Yields a single character token, one of {}()[]|=.;
        // or {"terminal",string} or {"ident", string} or -1.
        SkipSpaces();
        if (sdx >= src.Length)
        {
            token = new Token(-1, false);
            return;
        }
        int tokstart = sdx;
        if ("{}()[]|=.;".IndexOf(ch) >= 0)
        {
            sdx++;
            token = new Token(ch, false);
        }
        else if (ch == '"' || ch == '\'')
        {
            char closech = ch;
            int tokend = tokstart + 1;
            while (tokend < src.Length && src[tokend] != closech)
            {
                tokend++;
            }
            if (tokend >= src.Length)
            {
                token = new Token(Invalid("no closing quote"), false);
            }
            else
            {
                sdx = tokend + 1;
                token = new Token(new Sequence("terminal", src.Substring(tokstart + 1, tokend - tokstart - 1)), true);
            }
        }
        else if (ch >= 'a' && ch <= 'z')
        {
            // To simplify things for the purposes of this task,
            // identifiers are strictly a-z only, not A-Z or 1-9.
            while (sdx < src.Length && ch >= 'a' && ch <= 'z')
            {
                sdx++;
                if (sdx < src.Length)
                {
                    ch = src[sdx];
                }
            }
            token = new Token(new Sequence("ident", src.Substring(tokstart, sdx - tokstart)), true);
        }
        else
        {
            token = new Token(Invalid("invalid ebnf"), false);
        }
    }

    private void MatchToken(char expectedCh)
    {
        if (!token.Value.Equals(expectedCh))
        {
            token = new Token(Invalid($"invalid ebnf ({expectedCh} expected)"), false);
        }
        else
        {
            GetToken();
        }
    }

    private int AddIdent(string ident)
    {
        int k = idents.IndexOf(ident);
        if (k == -1)
        {
            idents.Add(ident);
            k = idents.Count - 1;
            ididx.Add(-1);
        }
        return k;
    }

    private object Factor()
    {
        object res;
        if (token.IsSequence)
        {
            Sequence t = (Sequence)token.Value;
            if (t[0].Equals("ident"))
            {
                int idx = AddIdent((string)t[1]);
                t.Add(idx);
                token.Value = t;
            }
            res = token.Value;
            GetToken();
        }
        else if (token.Value.Equals('['))
        {
            GetToken();
            res = new Sequence("optional", Expression());
            MatchToken(']');
        }
        else if (token.Value.Equals('('))
        {
            GetToken();
            res = Expression();
            MatchToken(')');
        }
        else if (token.Value.Equals('{'))
        {
            GetToken();
            res = new Sequence("repeat", Expression());
            MatchToken('}');
        }
        else
        {
            throw new InvalidOperationException("invalid token in Factor() function");
        }
        if (res is Sequence seq && seq.Count == 1)
        {
            return seq[0];
        }
        return res;
    }

    private object Term()
    {
        Sequence res = new Sequence(Factor());
        object[] tokens = { -1, '|', '.', ';', ')', ']', '}' };

        while (true)
        {
            bool found = false;
            foreach (object t in tokens)
            {
                if (t.Equals(token.Value))
                {
                    found = true;
                    break;
                }
            }
            if (found) break;

            res.Add(Factor());
        }

        if (res.Count == 1)
        {
            return res[0];
        }
        return res;
    }

    private object Expression()
    {
        Sequence res = new Sequence(Term());
        if (token.Value.Equals('|'))
        {
            res = new Sequence("or", res[0]);
            while (token.Value.Equals('|'))
            {
                GetToken();
                res.Add(Term());
            }
        }
        if (res.Count == 1)
        {
            return res[0];
        }
        return res;
    }

    private object Production()
    {
        // Returns a token or -1; the real result is left in 'productions' etc,
        GetToken();
        if (!token.Value.Equals('}'))
        {
            if (token.Value.Equals(-1))
            {
                return Invalid("invalid ebnf (missing closing })");
            }
            if (!token.IsSequence)
            {
                return -1;
            }
            Sequence t = (Sequence)token.Value;
            if (!t[0].Equals("ident"))
            {
                return -1;
            }
            string ident = (string)t[1];
            int idx = AddIdent(ident);
            GetToken();
            MatchToken('=');
            if (token.Value.Equals(-1))
            {
                return -1;
            }
            productions.Add(new Sequence(ident, idx, Expression()));
            ididx[idx] = productions.Count - 1;
        }
        return token.Value;
    }

    private int Parse(string ebnf)
    {
        // Returns +1 if ok, -1 if bad.
        Console.WriteLine($"parse:\n{ebnf} ===>");
        err = false;
        src = ebnf;
        sdx = 0;
        idents.Clear();
        ididx.Clear();
        productions.Clear();
        extras.Clear();

        GetToken();
        if (token.IsSequence)
        {
            Sequence t = (Sequence)token.Value;
            t[0] = "title";
            extras.Add(token.Value);
            GetToken();
        }
        if (!token.Value.Equals('{'))
        {
            return Invalid("invalid ebnf (missing opening {)");
        }

        while (true)
        {
            object tokenResult = Production();
            if (tokenResult.Equals('}') || tokenResult.Equals(-1))
            {
                break;
            }
        }

        GetToken();
        if (token.IsSequence)
        {
            Sequence t = (Sequence)token.Value;
            t[0] = "comment";
            extras.Add(token.Value);
            GetToken();
        }
        if (!token.Value.Equals(-1))
        {
            return Invalid("invalid ebnf (missing eof?)");
        }
        if (err)
        {
            return -1;
        }

        int k = -1;
        for (int i = 0; i < ididx.Count; i++)
        {
            if (ididx[i] == -1)
            {
                k = i;
                break;
            }
        }
        if (k != -1)
        {
            return Invalid($"invalid ebnf (undefined:{idents[k]})");
        }

        PPrint(productions, "productions");
        PPrint(idents, "idents");
        PPrint(ididx, "ididx");
        PPrint(extras, "extras");
        return 1;
    }

    // Adjusts C#'s normal printing to look more like Phix output.
    private void PPrint(object ob, string header)
    {
        Console.WriteLine($"\n{header}:");
        string pp = ob.ToString();
        pp = pp.Replace("[", "{");
        pp = pp.Replace("]", "}");
        pp = pp.Replace(" ", ", ");
        for (int i = 0; i < idents.Count; i++)
        {
            pp = pp.Replace(i.ToString(), i.ToString());
        }
        Console.WriteLine(pp);
    }

    // The rules that Applies() has to deal with are:
    // {factors} - if rule[0] is not string,
    // just apply one after the other recursively.
    // {"terminal", "a1"}       -- literal constants
    // {"or", <e1>, <e2>, ...}  -- (any) one of n
    // {"repeat", <e1>}         -- as per "{}" in ebnf
    // {"optional", <e1>}       -- as per "[]" in ebnf
    // {"ident", <name>, idx}   -- apply the sub-rule

    private bool Applies(Sequence rule)
    {
        int wasSdx = sdx; // in case of failure
        object r1 = rule[0];

        if (!(r1 is string))
        {
            for (int i = 0; i < rule.Count; i++)
            {
                if (!Applies((Sequence)rule[i]))
                {
                    sdx = wasSdx;
                    return false;
                }
            }
        }
        else if (r1.Equals("terminal"))
        {
            SkipSpaces();
            string r2 = (string)rule[1];
            for (int i = 0; i < r2.Length; i++)
            {
                if (sdx >= src.Length || src[sdx] != r2[i])
                {
                    sdx = wasSdx;
                    return false;
                }
                sdx++;
            }
        }
        else if (r1.Equals("or"))
        {
            for (int i = 1; i < rule.Count; i++)
            {
                if (Applies((Sequence)rule[i]))
                {
                    return true;
                }
            }
            sdx = wasSdx;
            return false;
        }
        else if (r1.Equals("repeat"))
        {
            while (Applies((Sequence)rule[1]))
            {
                // continue repeating
            }
        }
        else if (r1.Equals("optional"))
        {
            Applies((Sequence)rule[1]);
        }
        else if (r1.Equals("ident"))
        {
            int i = (int)rule[2];
            int ii = ididx[i];
            if (!Applies((Sequence)productions[ii][2]))
            {
                sdx = wasSdx;
                return false;
            }
        }
        else
        {
            throw new InvalidOperationException("invalid rule in Applies() function");
        }
        return true;
    }

    private void CheckValid(string test)
    {
        src = test;
        sdx = 0;
        bool res = Applies((Sequence)productions[0][2]);
        SkipSpaces();
        if (sdx < src.Length)
        {
            res = false;
        }
        Console.WriteLine($"\"{test}\", {results[1 - BoolToInt(res)]}");
    }

    public static void Main(string[] args)
    {
        EBNFParser parser = new EBNFParser();

        string[] ebnfs = {
            "\"a\" {\n" +
            "    a = \"a1\" ( \"a2\" | \"a3\" ) { \"a4\" } [ \"a5\" ] \"a6\" ;\n" +
            "} \"z\" ",

            "{\n" +
            "    expr = term { plus term } .\n" +
            "    term = factor { times factor } .\n" +
            "    factor = number | '(' expr ')' .\n" +
            " \n" +
            "    plus = \"+\" | \"-\" .\n" +
            "    times = \"*\" | \"/\" .\n" +
            " \n" +
            "    number = digit { digit } .\n" +
            "    digit = \"0\" | \"1\" | \"2\" | \"3\" | \"4\" | \"5\" | \"6\" | \"7\" | \"8\" | \"9\" .\n" +
            "}",

            "a = \"1\"",
            "{ a = \"1\" ;",
            "{ hello world = \"1\"; }",
            "{ foo = bar . }"
        };

        string[][] tests = {
            new string[] {
                "a1a3a4a4a5a6",
                "a1 a2a6",
                "a1 a3 a4 a6",
                "a1 a4 a5 a6",
                "a1 a2 a4 a5 a5 a6",
                "a1 a2 a4 a5 a6 a7",
                "your ad here"
            },
            new string[] {
                "2",
                "2*3 + 4/23 - 7",
                "(3 + 4) * 6-2+(4*(4))",
                "-2",
                "3 +",
                "(4 + 3"
            }
        };

        for (int i = 0; i < ebnfs.Length; i++)
        {
            if (parser.Parse(ebnfs[i]) == 1)
            {
                Console.WriteLine("\ntests:");
                if (i < tests.Length)
                {
                    foreach (string test in tests[i])
                    {
                        parser.CheckValid(test);
                    }
                }
            }
            Console.WriteLine();
        }
    }
}
