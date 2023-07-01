using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    public static void Main() {
        var sequence = new[] { "A", "B", "C", "D" };
        foreach (var subset in Subsets(sequence.Length).Where(s => !IsContinuous(s))) {
            Console.WriteLine(string.Join(" ", subset.Select(i => sequence[i])));
        }
    }

    static IEnumerable<List<int>> Subsets(int length) {
        int[] values = Enumerable.Range(0, length).ToArray();
        var stack = new Stack<int>(length);
        for (int i = 0; stack.Count > 0 || i < length; ) {
            if (i < length) {
                stack.Push(i++);
                yield return (from index in stack.Reverse() select values[index]).ToList();
            } else {
                i = stack.Pop() + 1;
                if (stack.Count > 0) i = stack.Pop() + 1;
            }
        }
    }

    static bool IsContinuous(List<int> list) => list[list.Count - 1] - list[0] + 1 == list.Count;

}
