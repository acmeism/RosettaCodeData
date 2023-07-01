using System;
using System.Collections.Generic;
using static System.Console;
using static System.Linq.Enumerable;

public static class SquareButNotCube
{
    public static void Main() {
        var squares = from i in Integers() select i * i;
        var cubes = from i in Integers() select i * i * i;

        foreach (var x in Merge().Take(33)) {
            WriteLine(x.isCube ? x.n + " (also cube)" : x.n + "");
        }

        IEnumerable<int> Integers() {
            for (int i = 1; ;i++) yield return i;
        }

        IEnumerable<(int n, bool isCube)> Merge() {
            using (var s = squares.GetEnumerator())
            using (var c = cubes.GetEnumerator()) {
                s.MoveNext();
                c.MoveNext();
                while (true) {
                    if (s.Current < c.Current) {
                        yield return (s.Current, false);
                        s.MoveNext();
                    } else if (s.Current == c.Current) {
                        yield return (s.Current, true);
                        s.MoveNext();
                        c.MoveNext();
                    } else {
                        c.MoveNext();
                    }
                }
            }
        }

    }
}
