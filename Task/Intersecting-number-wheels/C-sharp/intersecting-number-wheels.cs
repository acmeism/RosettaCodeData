using System;
using System.Collections.Generic;
using System.Linq;

public static class IntersectingNumberWheels
{
    public static void Main() {
        TurnWheels(('A', "123")).Take(20).Print();
        TurnWheels(('A', "1B2"), ('B', "34")).Take(20).Print();
        TurnWheels(('A', "1DD"), ('D', "678")).Take(20).Print();
        TurnWheels(('A', "1BC"), ('B', "34"), ('C', "5B")).Take(20).Print();
    }

    static IEnumerable<char> TurnWheels(params (char name, string values)[] wheels) {
        var data = wheels.ToDictionary(wheel => wheel.name, wheel => wheel.values.Loop().GetEnumerator());
        var primary = data[wheels[0].name];
        while (true) {
            yield return Turn(primary);
        }

        char Turn(IEnumerator<char> sequence) {
            sequence.MoveNext();
            char c = sequence.Current;
            return char.IsDigit(c) ? c : Turn(data[c]);
        }
    }

    static IEnumerable<T> Loop<T>(this IEnumerable<T> seq) {
        while (true) {
            foreach (T element in seq) yield return element;
        }
    }

    static void Print(this IEnumerable<char> sequence) => Console.WriteLine(string.Join(" ", sequence));
}
