using System;
using System.Linq;
using System.Net;

static class Program
{
    static void Main(string[] args)
    {
        WebClient client = new WebClient();
        string text = client.DownloadString("http://www.puzzlers.org/pub/wordlists/unixdict.txt");
        string[] words = text.Split(new char[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);

        var query = from w in words
                    where IsOrderedWord(w)
                    group w by w.Length into ows
                    orderby ows.Key descending
                    select ows;

        Console.WriteLine(string.Join(", ", query.First().ToArray()));
    }

    private static bool IsOrderedWord(string w)
    {
        for (int i = 1; i < w.Length; i++)
            if (w[i] < w[i - 1])
                return false;

        return true;
    }
}
