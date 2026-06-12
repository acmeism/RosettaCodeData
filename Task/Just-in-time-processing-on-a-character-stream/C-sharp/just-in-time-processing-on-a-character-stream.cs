using System;
using System.Collections.Generic;
using System.Linq;

namespace JustInTimeProcessing {
    struct UserInput {
        public UserInput(string ff, string lf, string tb, string sp) {
            FormFeed = (char)int.Parse(ff);
            LineFeed = (char)int.Parse(lf);
            Tab = (char)int.Parse(tb);
            Space = (char)int.Parse(sp);
        }

        public char FormFeed { get; }
        public char LineFeed { get; }
        public char Tab { get; }
        public char Space { get; }
    }

    class Program {
        static List<UserInput> GetUserInput() {
            string h = "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 "
                + "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28";
            return h.Split(' ')
                .Select((x, idx) => new { x, idx })
                .GroupBy(x => x.idx / 4)
                //.Select(g => g.Select(a => a.x))
                .Select(g => {
                    var ge = g.Select(a => a.x).ToArray();
                    return new UserInput(ge[0], ge[1], ge[2], ge[3]);
                })
                .ToList();
        }

        static void Decode(string filename, List<UserInput> uiList) {
            string text = System.IO.File.ReadAllText(filename);

            bool Decode2(UserInput ui) {
                char f = (char)0;
                char l = (char)0;
                char t = (char)0;
                char s = (char)0;

                foreach (char c in text) {
                    if (f == ui.FormFeed && l == ui.LineFeed && t == ui.Tab && s == ui.Space) {
                        if (c == '!') return false;
                        Console.Write(c);
                        return true;
                    }
                    if (c == '\u000c') {
                        f++; l = (char)0; t = (char)0; s = (char)0;
                    } else if (c == '\n') {
                        l++; t = (char)0; s = (char)0;
                    } else if (c == '\t') {
                        t++; s = (char)0;
                    } else {
                        s++;
                    }
                }

                return false;
            }

            foreach (UserInput ui in uiList) {
                if (!Decode2(ui)) {
                    break;
                }
            }
            Console.WriteLine();
        }

        static void Main(string[] args) {
            var uiList = GetUserInput();
            Decode("theraven.txt", uiList);

            Console.ReadLine();
        }
    }
}
