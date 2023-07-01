using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;

namespace Anagram
{
    class Program
    {
        const string DICO_URL = "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt";

        static void Main( string[] args )
        {
            WebRequest request = WebRequest.Create(DICO_URL);
            string[] words;
            using (StreamReader sr = new StreamReader(request.GetResponse().GetResponseStream(), true)) {
                words = Regex.Split(sr.ReadToEnd(), @"\r?\n");
            }
            var groups = from string w in words
                         group w by string.Concat(w.OrderBy(x => x)) into c
                         group c by c.Count() into d
                         orderby d.Key descending
                         select d;
            foreach (var c in groups.First()) {
                Console.WriteLine(string.Join(" ", c));
            }
        }
    }
}
