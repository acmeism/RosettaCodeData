using System;
using System.Collections.Generic;
using System.Linq;

public static class GraphColoring
{
    public static void Main(string[] args)
    {
        Colorize("0-1 1-2 2-0 3");
        Colorize("1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7");
        Colorize("1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6");
        Colorize("1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7");
    }

    private static void Colorize(string graphRepresentation)
    {
        List<Node> graph = InitializeGraph(graphRepresentation);
        List<Node> nodes = new List<Node>(graph);
        while (nodes.Any())
        {
            Node maxNode = nodes.OrderByDescending(n => n.Saturation).First();
            maxNode.Color = MinColor(maxNode);
            UpdateSaturation(maxNode, nodes);
            nodes.Remove(maxNode);
        }

        Console.WriteLine("Graph: " + graphRepresentation);
        Display(graph);
    }

    private static Color MinColor(Node node)
    {
        HashSet<Color> colorsUsed = ColorsUsed(node);
        foreach (Color color in Enum.GetValues(typeof(Color)))
        {
            if (!colorsUsed.Contains(color))
            {
                return color;
            }
        }
        return Color.NoColor;
    }

    private static HashSet<Color> ColorsUsed(Node node)
    {
        return new HashSet<Color>(node.Neighbours.Select(n => n.Color));
    }

    private static void UpdateSaturation(Node node, List<Node> nodes)
    {
        foreach (Node neighbour in node.Neighbours)
        {
            if (neighbour.Color == Color.NoColor)
            {
                neighbour.Saturation = ColorsUsed(neighbour).Count;
            }
        }
    }

    private static void Display(List<Node> nodes)
    {
        HashSet<Color> graphColors = new HashSet<Color>(nodes.Select(n => n.Color));
        foreach (Node node in nodes)
        {
            Console.Write($"Node {node.Index}:   color = {node.Color}");
            if (node.Neighbours.Any())
            {
                var indexes = node.Neighbours.Select(n => n.Index).ToList();
                Console.Write(new string(' ', 8 - node.Color.ToString().Length) + "neighbours = " + string.Join(", ", indexes));
            }
            Console.WriteLine();
        }

        Console.WriteLine("Number of colours used: " + graphColors.Count);
        Console.WriteLine();
    }

    private static List<Node> InitializeGraph(string graphRepresentation)
    {
        SortedDictionary<int, Node> map = new SortedDictionary<int, Node>();
        foreach (string element in graphRepresentation.Split(' '))
        {
            if (element.Contains("-"))
            {
                string[] parts = element.Split('-');
                int index1 = int.Parse(parts[0]);
                int index2 = int.Parse(parts[1]);
                Node node1 = map.GetOrAdd(index1, () => new Node(index1));
                Node node2 = map.GetOrAdd(index2, () => new Node(index2));
                node1.Neighbours.Add(node2);
                node2.Neighbours.Add(node1);
            }
            else
            {
                int index = int.Parse(element);
                map.GetOrAdd(index, () => new Node(index));
            }
        }

        return new List<Node>(map.Values);
    }

    public enum Color { Blue, Green, Red, Yellow, Cyan, Orange, NoColor }

    public class Node
    {
        public Node(int index)
        {
            Index = index;
            Color = Color.NoColor;
            Neighbours = new HashSet<Node>();
        }

        public int Index { get; }
        public int Saturation { get; set; }
        public Color Color { get; set; }
        public HashSet<Node> Neighbours { get; }
    }

    private static TValue GetOrAdd<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, Func<TValue> valueFactory)
    {
        if (!dictionary.TryGetValue(key, out TValue value))
        {
            value = valueFactory();
            dictionary[key] = value;
        }
        return value;
    }
}
