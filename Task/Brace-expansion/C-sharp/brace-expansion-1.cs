using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using static System.Linq.Enumerable;

public static class BraceExpansion
{
    enum TokenType { OpenBrace, CloseBrace, Separator, Text, Alternate, Concat }
    const char L = '{', R = '}', S = ',';

    public static void Main() {
        string[] input = {
            "It{{em,alic}iz,erat}e{d,}, please.",
            "~/{Downloads,Pictures}/*.{jpg,gif,png}",
            @"{,{,gotta have{ ,\, again\, }}more }cowbell!",
            @"{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}"
        };
        foreach (string text in input) Expand(text);
    }

    static void Expand(string input) {
        Token token = Tokenize(input);
        foreach (string value in token) Console.WriteLine(value);
        Console.WriteLine();
    }

    static Token Tokenize(string input) {
        var tokens = new List<Token>();
        var buffer = new StringBuilder();
        bool escaping = false;
        int level = 0;

        foreach (char c in input) {
            (escaping, level, tokens, buffer) = c switch {
                _ when escaping => (false, level, tokens, buffer.Append(c)),
                '\\' => (true, level, tokens, buffer.Append(c)),
                L => (escaping, level + 1,
                    tokens.With(buffer.Flush()).With(new Token(c.ToString(), TokenType.OpenBrace)), buffer),
                S when level > 0 => (escaping, level,
                    tokens.With(buffer.Flush()).With(new Token(c.ToString(), TokenType.Separator)), buffer),
                R when level > 0 => (escaping, level - 1,
                    tokens.With(buffer.Flush()).With(new Token(c.ToString(), TokenType.CloseBrace)).Merge(), buffer),
                _ => (escaping, level, tokens, buffer.Append(c))
            };
        }
        if (buffer.Length > 0) tokens.Add(buffer.Flush());
        for (int i = 0; i < tokens.Count; i++) {
            if (tokens[i].Type == TokenType.OpenBrace || tokens[i].Type == TokenType.Separator) {
                tokens[i] = tokens[i].Value; //Change to text
            }
        }
        return new Token(tokens, TokenType.Concat);
    }

    static List<Token> Merge(this List<Token> list) {
        int separators = 0;
        int last = list.Count - 1;
        for (int i = list.Count - 3; i >= 0; i--) {
            if (list[i].Type == TokenType.Separator) {
                separators++;
                Concat(list, i + 1, last);
                list.RemoveAt(i);
                last = i;
            } else if (list[i].Type == TokenType.OpenBrace) {
                Concat(list, i + 1, last);
                if (separators > 0) {
                    list[i] = new Token(list.Range((i+1)..^1), TokenType.Alternate);
                    list.RemoveRange(i+1, list.Count - i - 1);
                } else {
                    list[i] = L.ToString();
                    list[^1] = R.ToString();
                    Concat(list, i, list.Count);
                }
                break;
            }
        }
        return list;
    }

    static void Concat(List<Token> list, int s, int e) {
        for (int i = e - 2; i >= s; i--) {
            (Token a, Token b) = (list[i], list[i+1]);
            switch (a.Type, b.Type) {
                case (TokenType.Text, TokenType.Text):
                    list[i] = a.Value + b.Value;
                    list.RemoveAt(i+1);
                    break;
                case (TokenType.Concat, TokenType.Concat):
                    a.SubTokens.AddRange(b.SubTokens);
                    list.RemoveAt(i+1);
                    break;
                case (TokenType.Concat, TokenType.Text) when b.Value == "":
                    list.RemoveAt(i+1);
                    break;
                case (TokenType.Text, TokenType.Concat) when a.Value == "":
                    list.RemoveAt(i);
                    break;
                default:
                    list[i] = new Token(new [] { a, b }, TokenType.Concat);
                    list.RemoveAt(i+1);
                    break;
            }
        }
    }

    private struct Token : IEnumerable<string>
    {
        private List<Token>? _subTokens;

        public string Value { get; }
        public TokenType Type { get; }
        public List<Token> SubTokens => _subTokens ??= new List<Token>();

        public Token(string value, TokenType type) => (Value, Type, _subTokens) = (value, type, null);
        public Token(IEnumerable<Token> subTokens, TokenType type) => (Value, Type, _subTokens) = ("", type, subTokens.ToList());

        public static implicit operator Token(string value) => new Token(value, TokenType.Text);

        public IEnumerator<string> GetEnumerator() => (Type switch
        {
            TokenType.Concat => SubTokens.Select(t => t.AsEnumerable()).CartesianProduct().Select(p => string.Join("", p)),
            TokenType.Alternate => from t in SubTokens from s in t select s,
            _ => Repeat(Value, 1)
        }).GetEnumerator();

        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }

    //===Extension methods===
    static IEnumerable<IEnumerable<T>> CartesianProduct<T>(this IEnumerable<IEnumerable<T>> sequences) {
        IEnumerable<IEnumerable<T>> emptyProduct = new[] { Empty<T>() };
        return sequences.Aggregate(
            emptyProduct,
            (accumulator, sequence) =>
                from acc in accumulator
                from item in sequence
                select acc.Concat(new [] { item }));
    }

    static List<Token> With(this List<Token> list, Token token) {
        list.Add(token);
        return list;
    }

    static IEnumerable<Token> Range(this List<Token> list, Range range) {
        int start = range.Start.GetOffset(list.Count);
        int end = range.End.GetOffset(list.Count);
        for (int i = start; i < end; i++) yield return list[i];
    }

    static string Flush(this StringBuilder builder) {
        string result = builder.ToString();
        builder.Clear();
        return result;
    }
}
