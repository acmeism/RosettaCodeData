using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;

namespace ReadlineInterface {
    class Program {
        static LinkedList<string> histArr = new LinkedList<string>();

        static void AppendHistory([CallerMemberName] string name = "unknown") {
            histArr.AddLast(name);
        }

        static void Hist() {
            if (histArr.Count == 0) {
                Console.WriteLine("No history");
            }
            else {
                foreach (string cmd in histArr) {
                    Console.WriteLine(" - {0}", cmd);
                }
            }
            AppendHistory();
        }

        static void Hello() {
            Console.WriteLine("Hello World!");
            AppendHistory();
        }

        static void Help() {
            Console.WriteLine("Available commands:");
            Console.WriteLine("  hello");
            Console.WriteLine("  hist");
            Console.WriteLine("  exit");
            Console.WriteLine("  help");
            AppendHistory();
        }

        static void Main(string[] args) {
            Dictionary<string, Action> cmdDict = new Dictionary<string, Action>();
            cmdDict.Add("help", Help);
            cmdDict.Add("hist", Hist);
            cmdDict.Add("hello", Hello);

            Console.WriteLine("Enter a command, type help for a listing.");
            while (true) {
                Console.Write(">");
                string line = Console.ReadLine();
                if (line=="exit") {
                    break;
                }

                Action action;
                if (cmdDict.TryGetValue(line, out action)) {
                    action.Invoke();
                } else {
                    Help();
                }
            }
        }
    }
}
