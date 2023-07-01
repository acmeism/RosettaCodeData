using System;
using System.Collections.Generic;
using System.Linq;

static class Program {
    static Random Rng = new Random((int)DateTime.Now.Ticks);

    static char NextCharacter(this Random self) {
        const string AllowedChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        return AllowedChars[self.Next() % AllowedChars.Length];
    }

    static string NextString(this Random self, int length) {
        return String.Join("", Enumerable.Repeat(' ', length)
            .Select(c => Rng.NextCharacter()));
    }

    static int Fitness(string target, string current) {
        return target.Zip(current, (a, b) => a == b ? 1 : 0).Sum();
    }

    static string Mutate(string current, double rate) {
        return String.Join("", from c in current
               select Rng.NextDouble() <= rate ? Rng.NextCharacter() : c);
    }

    static void Main(string[] args) {
        const string target = "METHINKS IT IS LIKE A WEASEL";
        const int C = 100;
        const double P = 0.05;

        // Start with a random string the same length as the target.
        string parent = Rng.NextString(target.Length);

        Console.WriteLine("START:       {0,20} fitness: {1}",
            parent, Fitness(target, parent));
        int i = 0;

        while (parent != target) {
            // Create C mutated strings + the current parent.
            var candidates = Enumerable.Range(0, C + 1)
                .Select(n => n > 0 ? Mutate(parent, P) : parent);

            // select the fittest
            parent = candidates.OrderByDescending(c => Fitness(target, c)).First();

            ++i;
            Console.WriteLine("     #{0,6} {1,20} fitness: {2}",
                i, parent, Fitness(target, parent));
        }

        Console.WriteLine("END: #{0,6} {1,20}", i, parent);
    }
}
