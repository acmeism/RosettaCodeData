using System;
using System.Linq;
using System.Collections.Generic;

public class SetConsolidation
{
    public static void Main()
    {
        var setCollection1 = new[] {new[] {"A", "B"}, new[] {"C", "D"}};
        var setCollection2 = new[] {new[] {"A", "B"}, new[] {"B", "D"}};
        var setCollection3 = new[] {new[] {"A", "B"}, new[] {"C", "D"}, new[] {"B", "D"}};
        var setCollection4 = new[] {new[] {"H", "I", "K"}, new[] {"A", "B"}, new[] {"C", "D"},
            new[] {"D", "B"}, new[] {"F", "G", "H"}};
        var input = new[] {setCollection1, setCollection2, setCollection3, setCollection4};

        foreach (var sets in input) {
            Console.WriteLine("Start sets:");
            Console.WriteLine(string.Join(", ", sets.Select(s => "{" + string.Join(", ", s) + "}")));
            Console.WriteLine("Sets consolidated using Nodes:");
            Console.WriteLine(string.Join(", ", ConsolidateSets1(sets).Select(s => "{" + string.Join(", ", s) + "}")));
            Console.WriteLine("Sets consolidated using Set operations:");
            Console.WriteLine(string.Join(", ", ConsolidateSets2(sets).Select(s => "{" + string.Join(", ", s) + "}")));
            Console.WriteLine();
        }
    }

    /// <summary>
    /// Consolidates sets using a connected-component-finding-algorithm involving Nodes with parent pointers.
    /// The more efficient solution, but more elaborate code.
    /// </summary>
    private static IEnumerable<IEnumerable<T>> ConsolidateSets1<T>(IEnumerable<IEnumerable<T>> sets,
        IEqualityComparer<T> comparer = null)
    {
        var elements = new Dictionary<T, Node<T>>(comparer );
        foreach (var set in sets) {
            Node<T> top = null;
            foreach (T value in set) {
                Node<T> element;
                if (elements.TryGetValue(value, out element)) {
                    if (top != null) {
                        var newTop = element.FindTop();
                        top.Parent = newTop;
                        element.Parent = newTop;
                        top = newTop;
                    } else {
                        top = element.FindTop();
                    }
                } else {
                    elements.Add(value, element = new Node<T>(value));
                    if (top == null) top = element;
                    else element.Parent = top;
                }
            }
        }
        foreach (var g in elements.Values.GroupBy(element => element.FindTop().Value))
            yield return g.Select(e => e.Value);
    }

    private class Node<T>
    {
        public Node(T value, Node<T> parent = null) {
            Value = value;
            Parent = parent ?? this;
        }

        public T Value { get; }
        public Node<T> Parent { get; set; }

        public Node<T> FindTop() {
            var top = this;
            while (top != top.Parent) top = top.Parent;
            //Set all parents to the top element to prevent repeated iteration in the future
            var element = this;
            while (element.Parent != top) {
                var parent = element.Parent;
                element.Parent = top;
                element = parent;
            }
            return top;
        }
    }

    /// <summary>
    /// Consolidates sets using operations on the HashSet&lt;T&gt; class.
    /// Less efficient than the other method, but easier to write.
    /// </summary>
    private static IEnumerable<IEnumerable<T>> ConsolidateSets2<T>(IEnumerable<IEnumerable<T>> sets,
        IEqualityComparer<T> comparer = null)
    {
        if (comparer == null) comparer = EqualityComparer<T>.Default;
        var currentSets = sets.Select(s => new HashSet<T>(s)).ToList();
        int previousSize;
        do {
            previousSize = currentSets.Count;
            for (int i = 0; i < currentSets.Count - 1; i++) {
                for (int j = currentSets.Count - 1; j > i; j--) {
                    if (currentSets[i].Overlaps(currentSets[j])) {
                        currentSets[i].UnionWith(currentSets[j]);
                        currentSets.RemoveAt(j);
                    }
                }
            }
        } while (previousSize > currentSets.Count);
        foreach (var set in currentSets) yield return set.Select(value => value);
    }
}
