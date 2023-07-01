using System;
using System.Collections.Generic;
using System.Linq;

static class Program {
    static void Main() {
        Func<int, IEnumerable<int>> ms = m => Infinite().Select(i => (int)Math.Pow(i, m));
        var squares = ms(2);
        var cubes = ms(3);
        var filtered = squares.Where(square => cubes.First(cube => cube >= square) != square);
        var final = filtered.Skip(20).Take(10);
        foreach (var i in final) Console.WriteLine(i);
    }

    static IEnumerable<int> Infinite() {
        var i = 0;
        while (true) yield return i++;
    }
}
