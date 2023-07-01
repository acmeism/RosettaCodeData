using System;
using System.Collections.Generic;

namespace Abbreviations {
    class Program {
        static void Main(string[] args) {
            string[] lines = System.IO.File.ReadAllLines("days_of_week.txt");
            int i = 0;

            foreach (string line in lines) {
                i++;
                if (line.Length > 0) {
                    var days = line.Split();
                    if (days.Length != 7) {
                        throw new Exception("There aren't 7 days in line " + i);
                    }

                    Dictionary<string, int> temp = new Dictionary<string, int>();
                    foreach (string day in days) {
                        if (temp.ContainsKey(day)) {
                            Console.WriteLine(" ∞  {0}", line);
                            continue;
                        }
                        temp.Add(day, 1);
                    }

                    int len = 1;
                    while (true) {
                        temp.Clear();
                        foreach(string day in days) {
                            string key;
                            if (len < day.Length) {
                                key = day.Substring(0, len);
                            } else {
                                key = day;
                            }
                            if (temp.ContainsKey(key)) {
                                break;
                            }
                            temp.Add(key, 1);
                        }
                        if (temp.Count == 7) {
                            Console.WriteLine("{0,2:D}  {1}", len, line);
                            break;
                        }
                        len++;
                    }
                }
            }
        }
    }
}
