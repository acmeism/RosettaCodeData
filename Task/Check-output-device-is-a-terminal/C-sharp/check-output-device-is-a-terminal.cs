using System;

namespace CheckTerminal {
    class Program {
        static void Main(string[] args) {
            Console.WriteLine("Stdout is tty: {0}", Console.IsOutputRedirected);
        }
    }
}
