using System;
using System.Net;
using System.Linq;
using System.Text.RegularExpressions;
using System.Collections.Generic;

class Category {
    private string _title;
    private int _members;

    public Category(string title, int members) {
        _title = title;
        _members = members;
    }

    public string Title {
        get {
            return _title;
        }
    }

    public int Members {
        get {
            return _members;
        }
    }
}

class Program {
    static void Main(string[] args) {
        string get1 = new WebClient().DownloadString("http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Languages&cmlimit=500&format=json");
        string get2 = new WebClient().DownloadString("http://www.rosettacode.org/w/index.php?title=Special:Categories&limit=5000");

        MatchCollection match1 = new Regex("\"title\":\"Category:(.+?)\"").Matches(get1);
        MatchCollection match2 = new Regex("title=\"Category:(.+?)\">.+?</a>[^(]*\\((\\d+) members\\)").Matches(get2);

        string[] valids = match1.Cast<Match>().Select(x => x.Groups[1].Value).ToArray();
        List<Category> langs = new List<Category>();

        foreach (Match match in match2) {
            string category = match.Groups[1].Value;
            int members = Int32.Parse(match.Groups[2].Value);

            if (valids.Contains(category)) langs.Add(new Category(category, members));
        }

        langs = langs.OrderByDescending(x => x.Members).ToList();
        int count = 1;

        foreach (Category i in langs) {
            Console.WriteLine("{0,3}. {1,3} - {2}", count, i.Members, i.Title);
            count++;
        }
    }
}
