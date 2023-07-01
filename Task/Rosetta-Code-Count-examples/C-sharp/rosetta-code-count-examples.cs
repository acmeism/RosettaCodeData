using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Net;

class Task {
    private string _task;
    private int _examples;

    public Task(string task, int examples) {
        _task = task;
        _examples = examples;
    }

    public string Name {
        get { return _task; }
    }

    public int Examples {
        get { return _examples; }
    }

    public override string ToString() {
        return String.Format("{0}: {1} examples.", this._task, this._examples);
    }
}

class Program {
    static List<string> GetTitlesFromCategory(string category, WebClient wc) {
        string content = wc.DownloadString(
            String.Format("http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:{0}&cmlimit=500&format=json", category)
        );

        return new Regex("\"title\":\"(.+?)\"").Matches(content).Cast<Match>().Select(x => x.Groups[1].Value.Replace("\\/", "/")).ToList();
    }

    static string GetSourceCodeFromPage(string page, WebClient wc) {
        return wc.DownloadString(
            String.Format("http://www.rosettacode.org/w/index.php?title={0}&action=raw", page)
        );
    }

    static void Main(string[] args) {
        WebClient wc = new WebClient();
        List<Task> tasks = new List<Task>();
        List<string> tasknames = GetTitlesFromCategory("Programming_Tasks", wc);

        foreach (string task in tasknames) {
            try {
                string content = GetSourceCodeFromPage(WebUtility.UrlEncode(task), wc);
                int count = new Regex("=={{header", RegexOptions.IgnoreCase).Matches(content).Count;
                Task t = new Task(task, count);

                Console.WriteLine(t);
                tasks.Add(t);
            }
            catch (Exception ex) {
                Console.WriteLine("****            Unable to get task \"" + task + "\": " + ex.Message);
            }
        }

        Console.WriteLine("\nTotal: {0} examples.", tasks.Select(x => x.Examples).Sum());
    }
}
