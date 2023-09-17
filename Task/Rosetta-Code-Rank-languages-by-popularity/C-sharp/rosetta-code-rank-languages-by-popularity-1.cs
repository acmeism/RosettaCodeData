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
        string get2 = new WebClient().DownloadString("http://www.rosettacode.org/w/index.php?"
                                                    +"title=Special:Categories&limit=5000"
                                                    );

        ArrayList langs = new ArrayList();
        Dictionary<string, int> qtdmbr = new Dictionary<string, int>();

        string cmcontinue = "";

        do
        {
            string get1 = new WebClient().DownloadString("http://www.rosettacode.org/w/api.php?"
                                                        +"action=query&list=categorymembers"
                                                        +"&cmtitle=Category:Programming_Languages"
                                                        +"&cmlimit=500&format=json"
                                                        +cmcontinue
                                                        );
            cmcontinue = "";
            MatchCollection languageMatch   = new Regex("\"title\":\"Category:(.+?)\"").Matches(get1);
            MatchCollection cmcontinueMatch = new Regex("cmcontinue\":\"([a-z0-9A-Z|]*)\"").Matches(get1);
            foreach (Match lang in languageMatch)   langs.Add(lang.Groups[1].Value);
            foreach (Match more in cmcontinueMatch) cmcontinue = "&cmcontinue=" + more.Groups[1].Value;
        }
        while( cmcontinue != "" );

        MatchCollection match2 =
            new Regex("title=\"Category:(.+?)\">.+?</a>[^(]*\\(([\\d,.]+) members\\)").Matches(get2);

        foreach (Match match in match2)
        {
            if (langs.Contains(match.Groups[1].Value))
            {
                qtdmbr.Add(match.Groups[1].Value, Int32.Parse(match.Groups[2].Value
                                                                             .Replace(",",string.Empty)
                                                                             .Replace(".",string.Empty)));
            }
        }

        string[] test =
            qtdmbr.OrderByDescending(x => x.Value).Select(x => String.Format("{0,4} {1}", x.Value, x.Key)).ToArray();

        int count = 1;

        foreach (string i in test)
        {
            Console.WriteLine("{0,4}: {1}", count, i);
            count++;
        }
    }
}
