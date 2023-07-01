using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.IO;

namespace TextProc2
{
    class Program
    {
        static void Main(string[] args)
        {
            Regex multiWhite = new Regex(@"\s+");
            Regex dateEx = new Regex(@"^\d{4}-\d{2}-\d{2}$");
            Regex valEx = new Regex(@"^\d+\.{1}\d{3}$");
            Regex flagEx = new Regex(@"^[1-9]{1}$");

            int missformcount = 0, totalcount = 0;
            Dictionary<int, string> dates = new Dictionary<int, string>();

            using (StreamReader sr = new StreamReader("readings.txt"))
            {
                string line = sr.ReadLine();
                while (line != null)
                {
                    line = multiWhite.Replace(line, @" ");
                    string[] splitLine = line.Split(' ');
                    if (splitLine.Length != 49)
                        missformcount++;
                    if (!dateEx.IsMatch(splitLine[0]))
                        missformcount++;
                    else
                        dates.Add(totalcount + 1, dateEx.Match(splitLine[0]).ToString());
                    int err = 0;
                    for (int i = 1; i < splitLine.Length; i++)
                    {
                        if (i%2 != 0)
                        {
                            if (!valEx.IsMatch(splitLine[i]))
                                err++;
                        }
                        else
                        {
                            if (!flagEx.IsMatch(splitLine[i]))
                                err++;
                        }
                    }
                    if (err != 0) missformcount++;
                    line = sr.ReadLine();
                    totalcount++;
                }
            }

            int goodEntries = totalcount - missformcount;
            Dictionary<string,List<int>> dateReverse = new Dictionary<string,List<int>>();

            foreach (KeyValuePair<int, string> kvp in dates)
            {
                if (!dateReverse.ContainsKey(kvp.Value))
                    dateReverse[kvp.Value] = new List<int>();
                dateReverse[kvp.Value].Add(kvp.Key);
            }

            Console.WriteLine(goodEntries + " valid Records out of " + totalcount);

            foreach (KeyValuePair<string, List<int>> kvp in dateReverse)
            {
                if (kvp.Value.Count > 1)
                    Console.WriteLine("{0} is duplicated at Lines : {1}", kvp.Key, string.Join(",", kvp.Value));
            }
        }
    }
}
