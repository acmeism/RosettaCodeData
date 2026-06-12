using System;

namespace TextBetween {
    class Program {
        static string TextBetween(string source, string beg, string end) {
            int startIndex;

            if (beg == "start") {
                startIndex = 0;
            }
            else {
                startIndex = source.IndexOf(beg);
                if (startIndex < 0) {
                    return "";
                }
                startIndex += beg.Length;
            }

            int endIndex = source.IndexOf(end, startIndex);
            if (endIndex < 0 || end == "end") {
                return source.Substring(startIndex);
            }
            return source.Substring(startIndex, endIndex - startIndex);
        }

        static void Print(string s, string b, string e) {
            Console.WriteLine("text: '{0}'", s);
            Console.WriteLine("start: '{0}'", b);
            Console.WriteLine("end: '{0}'", e);
            Console.WriteLine("result: '{0}'", TextBetween(s, b, e));
            Console.WriteLine();
        }

        static void Main(string[] args) {
            Print("Hello Rosetta Code world", "Hello ", " world");
            Print("Hello Rosetta Code world", "start", " world");
            Print("Hello Rosetta Code world", "Hello ", "end");
            Print("</div><div style=\"chinese\">你好嗎</div>", "<div style=\"chinese\">", "</div>");
            Print("<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>");
            Print("<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>");
            Print("The quick brown fox jumps over the lazy other fox", "quick ", " fox");
            Print("One fish two fish red fish blue fish", "fish ", " red");
            Print("FooBarBazFooBuxQuux", "Foo", "Foo");
        }
    }
}
