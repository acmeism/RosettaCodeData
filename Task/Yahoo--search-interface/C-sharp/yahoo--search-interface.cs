using System;
using System.Net;
using System.Text.RegularExpressions;
using System.Collections.Generic;

class YahooSearch {
    private string query;
    private string content;
    private int page;

    const string yahoo = "http://search.yahoo.com/search?";

    public YahooSearch(string query) : this(query, 0) { }

    public YahooSearch(string query, int page) {
        this.query = query;
        this.page = page;
        this.content = new WebClient()
            .DownloadString(
                string.Format(yahoo + "p={0}&b={1}", query, this.page * 10 + 1)
            );
    }

    public YahooResult[] Results {
        get {
            List<YahooResult> results = new List<YahooResult>();

            Func<string, string, string> substringBefore = (str, before) =>
            {
                int iHref = str.IndexOf(before);
                return iHref < 0 ? "" : str.Substring(0, iHref);
            };
            Func<string, string, string> substringAfter = (str, after) =>
            {
                int iHref = str.IndexOf(after);
                return iHref < 0 ? "" : str.Substring(iHref + after.Length);
            };
            Converter<string, string> getText = p =>
                Regex.Replace(p, "<[^>]*>", x => "");

            Regex rx = new Regex(@"
                <li>
                    <div \s class=""res"">
                        <div>
                            <h3>
                                <a \s (?'LinkAttributes'[^>]+)>
                                    (?'LinkText' .*?)
                                (?></a>)
                            </h3>
                        </div>
                        <div \s class=""abstr"">
                            (?'Abstract' .*?)
                        (?></div>)
                        .*?
                    (?></div>)
                </li>",
                RegexOptions.IgnorePatternWhitespace
                | RegexOptions.ExplicitCapture
            );
            foreach (Match e in rx.Matches(this.content)) {
                string rurl = getText(substringBefore(substringAfter(
                    e.Groups["LinkAttributes"].Value, @"href="""), @""""));
                string rtitle = getText(e.Groups["LinkText"].Value);
                string rcontent = getText(e.Groups["Abstract"].Value);

                results.Add(new YahooResult(rurl, rtitle, rcontent));
            }
            return results.ToArray();
        }
    }

    public YahooSearch NextPage() {
        return new YahooSearch(this.query, this.page + 1);
    }

    public YahooSearch GetPage(int page) {
        return new YahooSearch(this.query, page);
    }
}

class YahooResult {
    public string URL { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }

    public YahooResult(string url, string title, string content) {
        this.URL = url;
        this.Title = title;
        this.Content = content;
    }

    public override string ToString()
    {
        return string.Format("\nTitle: {0}\nLink:  {1}\nText:  {2}",
            Title, URL, Content);
    }
}

// Usage:

class Prog {
    static void Main() {
        foreach (int page in new[] { 0, 1 })
        {
            YahooSearch x = new YahooSearch("test", page);

            foreach (YahooResult result in x.Results)
            {
                Console.WriteLine(result);
            }
        }
    }
}
