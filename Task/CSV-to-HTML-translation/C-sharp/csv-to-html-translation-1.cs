using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

    class Program
    {
        private static string ConvertCsvToHtmlTable(string csvText)
        {
            //split the CSV, assume no commas or line breaks in text
            List<List<string>> splitString = new List<List<string>>();
            List<string> lineSplit = csvText.Split('\n').ToList();
            foreach (string line in lineSplit)
            {
                splitString.Add(line.Split(',').ToList());
            }

            //encode text safely, and create table
            string tableResult = "<table>";
            foreach(List<string> splitLine in splitString)
            {
                tableResult += "<tr>";
                foreach(string splitText in splitLine)
                {
                    tableResult += "<td>" + WebUtility.HtmlEncode(splitText) + "</td>";
                }
                tableResult += "</tr>";
            }
            tableResult += "</table>";
            return tableResult;
        }
    }
