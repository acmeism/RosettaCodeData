using System;
using System.IO;

class Program {
    static void Main(string[] args) {
        File.Move("input.txt","output.txt");
        File.Move(@"\input.txt",@"\output.txt");

        Directory.Move("docs","mydocs");
        Directory.Move(@"\docs",@"\mydocs");
    }
}
