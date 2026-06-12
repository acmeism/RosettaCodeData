using System;
using System.Collections.Generic;
using System.Linq;

public class BronKerboschAlgorithm
{
    private static List<List<string>> cliques = new List<List<string>>();

    public static void Main(string[] args)
    {
        var edges = new List<Edge>
        {
            new Edge("a", "b"), new Edge("b", "a"),
            new Edge("a", "c"), new Edge("c", "a"),
            new Edge("b", "c"), new Edge("c", "b"),
            new Edge("d", "e"), new Edge("e", "d"),
            new Edge("d", "f"), new Edge("f", "d"),
            new Edge("e", "f"), new Edge("f", "e")
        };

        // Build the graph as an adjacency list
        var graph = new Dictionary<string, HashSet<string>>();
        foreach (var edge in edges)
        {
            if (!graph.ContainsKey(edge.Start))
                graph[edge.Start] = new HashSet<string>();
            graph[edge.Start].Add(edge.End);
        }

        // Initialize current clique, candidates and processed vertices
        var currentClique = new SortedSet<string>();
        var candidates = new HashSet<string>(graph.Keys);
        var processedVertices = new HashSet<string>();

        // Execute the Bron-Kerbosch algorithm to collect the cliques
        BronKerbosch(currentClique, candidates, processedVertices, graph);

        // Sort the cliques for consistent display
        cliques = cliques.OrderBy(c => c, new ListComparer()).ToList();

        // Display the cliques
        Console.WriteLine("[{0}]", string.Join(", ", cliques.Select(c => "[" + string.Join(", ", c) + "]")));
    }

    private static void BronKerbosch(
        SortedSet<string> currentClique,
        HashSet<string> candidates,
        HashSet<string> processedVertices,
        Dictionary<string, HashSet<string>> graph)
    {
        if (candidates.Count == 0 && processedVertices.Count == 0)
        {
            if (currentClique.Count > 2)
            {
                cliques.Add(new List<string>(currentClique));
            }
            return;
        }

        // Select a pivot vertex from 'candidates' union 'processedVertices' with the maximum degree
        var union = new HashSet<string>(candidates);
        union.UnionWith(processedVertices);

        string pivot = union.OrderByDescending(v => graph.ContainsKey(v) ? graph[v].Count : 0).First();

        // 'possibles' are vertices in 'candidates' that are not neighbours of the 'pivot'
        var possibles = new HashSet<string>(candidates);
        if (graph.ContainsKey(pivot))
            possibles.ExceptWith(graph[pivot]);

        foreach (var vertex in possibles)
        {
            // Create a new clique including 'vertex'
            var newClique = new SortedSet<string>(currentClique);
            newClique.Add(vertex);

            // 'newCandidates' are the members of 'candidates' that are neighbours of 'vertex'
            var neighbours = graph.ContainsKey(vertex) ? graph[vertex] : new HashSet<string>();
            var newCandidates = new HashSet<string>(candidates);
            newCandidates.IntersectWith(neighbours);

            // 'newProcessedVertices' are members of 'processedVertices' that are neighbours of 'vertex'
            var newProcessedVertices = new HashSet<string>(processedVertices);
            newProcessedVertices.IntersectWith(neighbours);

            // Recursive call with the updated sets
            BronKerbosch(newClique, newCandidates, newProcessedVertices, graph);

            // Move 'vertex' from 'candidates' to 'processedVertices'
            candidates.Remove(vertex);
            processedVertices.Add(vertex);
        }
    }

    private class ListComparer : IComparer<List<string>>
    {
        public int Compare(List<string> x, List<string> y)
        {
            for (int i = 0; i < Math.Min(x.Count, y.Count); i++)
            {
                int comparison = x[i].CompareTo(y[i]);
                if (comparison != 0)
                    return comparison;
            }
            return x.Count.CompareTo(y.Count);
        }
    }

    private class Edge
    {
        public string Start { get; }
        public string End { get; }

        public Edge(string start, string end)
        {
            Start = start;
            End = end;
        }
    }
}
