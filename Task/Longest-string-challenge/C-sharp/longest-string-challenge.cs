string[] input = ["a", "bb", "ccc", "ddd", "ee", "f", "ggg"];

#pragma warning disable CA1860 // Avoid using 'Enumerable.Any()' extension method

string longest = "";
string template = "";

foreach (string line in input)
{
    string t = template;
    string l = line;

    foreach (var _ in line)
    {
        if (t.Any())
            t = t[..^1];
        else
        {
            longest = "";
            template = line;
            break;
        }

        if (l.Any())
            l = l[..^1];
    }

    if (!t.Any())
        longest += line;    // string concatenation, not addition
}

while (longest.Any())
{
    Console.WriteLine(longest[..template.Length]);
    longest = longest[template.Length..];
}
