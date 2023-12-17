using System;
using System;
using System.IO;
using System.Linq;
using System.Text;


class Program {
    private static char shift(char c) {
		return c.ToString().ToLower().First() switch {
			>= 'a' and <= 'm' => (char)(c + 13),
			>= 'n' and <= 'z' => (char)(c - 13),
			var _ => c
		};
    }

    static string Rot13(string s) => new string(s.Select(c => shift(c)).ToArray());


    static void Main(string[] args) {
        foreach (var file in args.Where(file => File.Exists(file))) {
            Console.WriteLine(Rot13(File.ReadAllText(file)));
        }
        if (!args.Any()) {
            Console.WriteLine(Rot13(Console.In.ReadToEnd()));
        }
    }
}
