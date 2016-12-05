using System;
using System.Collections.Generic;
using System.Linq;

public static class TwelveStatements
{
    public static void Main() {
        Func<Statements, bool>[] checks = {
            st => st[1],
            st => st[2] == (7.To(12).Count(i => st[i]) == 3),
            st => st[3] == (2.To(12, by: 2).Count(i => st[i]) == 2),
            st => st[4] == st[5].Implies(st[6] && st[7]),
            st => st[5] == (!st[2] && !st[3] && !st[4]),
            st => st[6] == (1.To(12, by: 2).Count(i => st[i]) == 4),
            st => st[7] == (st[2] != st[3]),
            st => st[8] == st[7].Implies(st[5] && st[6]),
            st => st[9] == (1.To(6).Count(i => st[i]) == 3),
            st => st[10] == (st[11] && st[12]),
            st => st[11] == (7.To(9).Count(i => st[i]) == 1),
            st => st[12] == (1.To(11).Count(i => st[i]) == 4)
        };

        for (Statements statements = new Statements(0); statements.Value < 4096; statements++) {
            int count = 0;
            int falseIndex = 0;
            for (int i = 0; i < checks.Length; i++) {
                if (checks[i](statements)) count++;
                else falseIndex = i;
            }
            if (count == 0) Console.WriteLine($"{"All wrong:", -13}{statements}");
            else if (count == 11) Console.WriteLine($"{$"Wrong at {falseIndex + 1}:", -13}{statements}");
            else if (count == 12) Console.WriteLine($"{"All correct:", -13}{statements}");
        }
    }

    struct Statements
    {
        public Statements(int value) : this() { Value = value; }

        public int Value { get; }

        public bool this[int index] => (Value & (1 << index - 1)) != 0;

        public static Statements operator ++(Statements statements) => new Statements(statements.Value + 1);

        public override string ToString() {
            Statements copy = this; //Cannot access 'this' in anonymous method...
            return string.Join(" ", from i in 1.To(12) select copy[i] ? "T" : "F");
        }

    }

    //Extension methods
    static bool Implies(this bool x, bool y) => !x || y;

    static IEnumerable<int> To(this int start, int end, int by = 1) {
        while (start <= end) {
            yield return start;
            start += by;
        }
    }

}
