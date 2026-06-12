static bool IsAbcCorrelated(string s)
{
    int a = 0, b = 0, c = 0;

    foreach (var ch in s)
    {
        switch (ch)
        {
            case 'a': a++; break;
            case 'b': b++; break;
            case 'c': c++; break;
        }
    }

    return a == b && a == c;
}

foreach (var word in new[] {"abc", "aabbcc", "abbc", "a", "",
    "the quick brown fox jumps over the lazy dog", "rosetta code", "hello, world!"})
{
    Console.WriteLine($"'{word}'\t{IsAbcCorrelated(word)}");
}
