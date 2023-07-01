public static class BraceExpansion
{
    const char L = '{', R = '}', S = ',';
    //Main method same as above

    static void Expand(string input) {
        foreach (string s in GetItem(input).Item1) Console.WriteLine(s);
        Console.WriteLine();
    }

    static (List<string>, string) GetItem(string s, int depth = 0) {
        var output = new List<string> {""};
        while (s.Length > 0) {
            string c = s[..1];
            if (depth > 0 && (c[0] == S || c[0] == R)) return (output, s);
            if (c[0] == L) {
                var x = GetGroup(s[1..], depth+1);
                if (!(x.Item1 is null)) {
                    (output, s) = ((from a in output from b in x.Item1 select a + b).ToList(), x.Item2);
                    continue;
                }
            }
            if (c[0] == '\\' && s.Length > 1) {
                c += s[1];
                s = s[1..];
            }
            (output, s) = ((from a in output select a + c).ToList(), s[1..]);
        }
        return (output, s);
    }

    static (List<string>?, string) GetGroup(string s, int depth) {
        var output = new List<string>();
        bool comma = false;
        while (s.Length > 0) {
            List<string>? g;
            (g, s) = GetItem(s, depth);
            if (s.Length == 0) break;
            output.AddRange(g);

            if (s[0] == R) {
                if (comma) return (output, s[1..]);
                return ((from a in output select L + a + R).ToList(), s[1..]);
            }
            if (s[0] == S) (comma, s) = (true, s[1..]);
        }
        return (null, "");
    }
}
