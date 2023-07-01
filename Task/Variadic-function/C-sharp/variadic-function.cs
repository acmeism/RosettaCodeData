using System;

class Program {
    static void Main(string[] args) {
        PrintAll("test", "rosetta code", 123, 5.6);
    }

    static void PrintAll(params object[] varargs) {
        foreach (var i in varargs) {
            Console.WriteLine(i);
        }
    }
}
