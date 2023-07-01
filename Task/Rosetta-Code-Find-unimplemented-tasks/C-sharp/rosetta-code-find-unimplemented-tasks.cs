using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Net;

class Program {
    static List<string> GetTitlesFromCategory(string category) {
        string searchQueryFormat = "http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:{0}&format=json{1}";
        List<string> results = new List<string>();
        string cmcontinue = string.Empty;

        do {
            string cmContinueKeyValue;

            //append continue variable as needed
            if (cmcontinue.Length > 0)
                cmContinueKeyValue = String.Format("&cmcontinue={0}", cmcontinue);
            else
                cmContinueKeyValue = String.Empty;

            //execute query
            string query = String.Format(searchQueryFormat, category, cmContinueKeyValue);
            string content = new WebClient().DownloadString(query);

            results.AddRange(new Regex("\"title\":\"(.+?)\"").Matches(content).Cast<Match>().Select(x => x.Groups[1].Value));

            //detect if more results are available
            cmcontinue = Regex.Match(content, @"{""cmcontinue"":""([^""]+)""}", RegexOptions.IgnoreCase).Groups["1"].Value;
        } while (cmcontinue.Length > 0);

        return results;
    }

    static string[] GetUnimplementedTasksFromLanguage(string language) {
        List<string> alltasks = GetTitlesFromCategory("Programming_Tasks");
        List<string> lang = GetTitlesFromCategory(language);

        return alltasks.Where(x => !lang.Contains(x)).ToArray();
    }

    static void Main(string[] args) {
        string[] unimpl = GetUnimplementedTasksFromLanguage(args[0]);

        foreach (string i in unimpl) Console.WriteLine(i);
    }
}
