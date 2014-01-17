using System.Collections.Generic;
using System.IO;

class Program {
    static void Main() {
        var files = new List<string> {
            "test1.txt",
            "test2.txt"
        };
        foreach (string file in files) {
            File.WriteAllText(file, File.ReadAllText(file).Replace("Goodbye London!", "Hello New York!"));
        }
    }
}
