using System;
using System.Collections.Generic;
using System.Linq;

public class Program
{
    public static void Main() {
        var baseData = new Dictionary<string, object> {
            ["name"] = "Rocket Skates",
            ["price"] = 12.75,
            ["color"] = "yellow"
        };
        var updateData = new Dictionary<string, object> {
            ["price"] = 15.25,
            ["color"] = "red",
            ["year"] = 1974
        };
        var mergedData = new Dictionary<string, object>();
        foreach (var entry in baseData.Concat(updateData)) {
            mergedData[entry.Key] = entry.Value;
        }
        foreach (var entry in mergedData) {
            Console.WriteLine(entry);
        }
   }
}
