using System;
using System.IO;

class Program {
    static void Main(string[] args) {
        File.Create("output.txt");
        File.Create(@"\output.txt");

        Directory.CreateDirectory("docs");
        Directory.CreateDirectory(@"\docs");
    }
}
