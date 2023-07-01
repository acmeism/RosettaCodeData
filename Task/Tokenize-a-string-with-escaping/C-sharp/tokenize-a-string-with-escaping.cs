using System;
using System.Text;
using System.Collections.Generic;

public class TokenizeAStringWithEscaping
{
    public static void Main() {
        string testcase = "one^|uno||three^^^^|four^^^|^cuatro|";
        foreach (var token in testcase.Tokenize(separator: '|', escape: '^')) {
            Console.WriteLine(": " + token); //Adding a : so we can see empty lines
        }
    }
}

public static class Extensions
{
    public static IEnumerable<string> Tokenize(this string input, char separator, char escape) {
        if (input == null) yield break;
        var buffer = new StringBuilder();
        bool escaping = false;
        foreach (char c in input) {
            if (escaping) {
                buffer.Append(c);
                escaping = false;
            } else if (c == escape) {
                escaping = true;
            } else if (c == separator) {
                yield return buffer.Flush();
            } else {
                buffer.Append(c);
            }
        }
        if (buffer.Length > 0 || input[input.Length-1] == separator) yield return buffer.Flush();
    }

    public static string Flush(this StringBuilder stringBuilder) {
        string result = stringBuilder.ToString();
        stringBuilder.Clear();
        return result;
    }
}
