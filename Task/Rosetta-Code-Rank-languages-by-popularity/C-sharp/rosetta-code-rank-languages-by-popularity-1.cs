using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;

class Program
{
    static void Main(string[] args)
    {
        string get1 = new WebClient().DownloadString("http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Languages&cmlimit=500&format=json");
        string get2 = new WebClient().DownloadString("http://www.rosettacode.org/w/index.php?title=Special:Categories&limit=5000");

        ArrayList langs = new ArrayList();
        Dictionary<string, int> qtdmbr = new Dictionary<string, int>();

        MatchCollection match1 = new Regex("\"title\":\"Category:(.+?)\"").Matches(get1);
        MatchCollection match2 = new Regex("title=\"Category:(.+?)\">.+?</a>[^(]*\\((\\d+) members\\)").Matches(get2);

        foreach (Match lang in match1) langs.Add(lang.Groups[1].Value);

        foreach (Match match in match2)
        {
            if (langs.Contains(match.Groups[1].Value))
            {
                qtdmbr.Add(match.Groups[1].Value, Int32.Parse(match.Groups[2].Value));
            }
        }

        string[] test = qtdmbr.OrderByDescending(x => x.Value).Select(x => String.Format("{0,3} - {1}", x.Value, x.Key)).ToArray();

        int count = 1;

        foreach (string i in test)
        {
            Console.WriteLine("{0,3}. {1}", count, i);
            count++;
        }
    }
}
