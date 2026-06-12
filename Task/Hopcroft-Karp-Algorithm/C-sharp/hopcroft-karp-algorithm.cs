using System;
using System.Collections.Generic;
using System.Linq;

public sealed class HopcroftKarpAlgorithm
{
    // Define Edge class instead of record
    private sealed class Edge
    {
        public int From { get; }
        public int To { get; }

        public Edge(int from, int to)
        {
            From = from;
            To = to;
        }
    }

    public static void Main(string[] args)
    {
        Console.WriteLine("Running tests:");
        int successCount = 0;

        // Test Case 1
        successCount = TestValue(1, 3, 5, new List<Edge> { new Edge(1, 4) }, 1);

        // Test Case 2
        successCount += TestValue(2, 6, 6, new List<Edge> { new Edge(1, 4), new Edge(1, 5), new Edge(5, 1) }, 2);

        // Test Case 3: Complete Bipartite Graph K(3, 3)
        var edges = new List<Edge>();
        for (int i = 1; i <= 3; i++)
        {
            for (int j = 1; j <= 3; j++)
            {
                edges.Add(new Edge(i, j));
            }
        }
        successCount += TestValue(3, 3, 3, edges, 3);

        // Test Case 4: No edges
        successCount += TestValue(4, 2, 2, new List<Edge>(), 0);

        // Test Case 5
        edges = new List<Edge>
        {
            new Edge(1, 1), new Edge(1, 3), new Edge(2, 3), new Edge(3, 4), new Edge(4, 3), new Edge(4, 2)
        };
        successCount += TestValue(5, 4, 4, edges, 4);

        if (successCount == 5)
        {
            Console.WriteLine("All tests passed.");
        }
    }

    private static int TestValue(int testNumber, int m, int n, List<Edge> edges, int expectedResult)
    {
        BipartiteGraph graph = new BipartiteGraph(m, n);
        foreach (var edge in edges)
        {
            graph.AddEdge(edge.From, edge.To);
        }
        int result = graph.HopcroftKarpAlgorithm();
        Console.WriteLine($"Test {testNumber}: Result = {result}, Expected = {expectedResult}");
        if (result == expectedResult)
        {
            return 1;
        }

        Console.WriteLine($"Test {testNumber} failed.");
        return 0;
    }
}

/// <summary>
/// Representation of a bipartite graph.
/// Vertices in the left partition, U, are numbered from 1 to m,
/// and vertices in the right partition, V, are numbered 1 to n.
/// </summary>
internal sealed class BipartiteGraph
{
    public BipartiteGraph(int aM, int aN)
    {
        m = aM;
        n = aN;

        adjacencyLists = Enumerable.Range(0, m + 1)
                                  .Select(i => new List<int>()).ToList();
        pairU = Enumerable.Repeat(NIL, m + 1).ToList();
        pairV = Enumerable.Repeat(NIL, n + 1).ToList();
        levels = Enumerable.Repeat(INFINITY, m + 1).ToList();
    }

    public void AddEdge(int u, int v)
    {
        if (1 <= u && u <= m && 1 <= v && v <= n)
        {
            adjacencyLists[u].Add(v);
        }
        else
        {
            throw new InvalidOperationException($"Attempt to add an edge ({u}, {v}) which is out of bounds");
        }
    }

    /// <summary>
    /// Return the matching size of the bipartite graph.
    /// </summary>
    public int HopcroftKarpAlgorithm()
    {
        pairU = Enumerable.Repeat(NIL, m + 1).ToList();
        pairV = Enumerable.Repeat(NIL, n + 1).ToList();
        int matchingSize = 0;

        while (BreadthFirstSearch())
        {
            for (int u = 1; u <= m; u++)
            {
                if (pairU[u] == NIL && DepthFirstSearch(u))
                {   // vertex u is free and an augmenting path starting
                    matchingSize += 1;  // from u has been found by the depth first search
                }
            }
        }
        return matchingSize;
    }

    /// <summary>
    /// Determines whether there exists an augmenting path starting from a free vertex in U.
    ///
    /// Return true if an augmenting path could exist, otherwise false.
    /// </summary>
    private bool BreadthFirstSearch()
    {
        Queue<int> queue = new Queue<int>();
        for (int u = 1; u <= m; u++)
        { // Initialise 'levels' for the vertices in U
            if (pairU[u] == NIL)
            { // If u is a free vertex, its level is 0 add it is added to the queue
                levels[u] = 0;
                queue.Enqueue(u);
            }
            else
            { // Otherwise, set 'levels' to infinity
                levels[u] = INFINITY;
            }
        }

        // The 'level' to the NIL node represents the length of the shortest augmenting path
        levels[NIL] = INFINITY;

        while (queue.Count > 0)
        {
            int u = queue.Dequeue();
            if (levels[u] < levels[NIL])
            { // The path through u could lead to a shorter augmenting path
                foreach (int v in adjacencyLists[u])
                { // Explore the neighbours v of u in V
                    int matchedU = pairV[v];
                    if (levels[matchedU] == INFINITY)
                    { // The matched vertex has not been visited yet
                        levels[matchedU] = levels[u] + 1;
                        queue.Enqueue(matchedU); // Enqueue the matched vertex to explore it further
                    }
                }
            }
        }

        // An augmenting path from the initial free vertices was found if levels[NIL] is not INFINITY
        return levels[NIL] != INFINITY;
    }

    /// <summary>
    /// Determine whether the shortest path from vertex u in U found by BreadthFirstSearch() can be augmented.
    ///
    /// Return true if an augmenting path was found starting from u, otherwise false.
    /// </summary>
    private bool DepthFirstSearch(int u)
    {
        if (u != NIL)
        {
            foreach (int v in adjacencyLists[u])
            { // Explore neighbours v of u in V
                int matchedU = pairV[v];
                // Check whether the edge (u, v) leads to a vertex matchedU
                // such that the path u -> v -> matchedU is part of a shortest augmenting path
                if (levels[matchedU] == levels[u] + 1)
                {
                    if (DepthFirstSearch(matchedU))
                    { // An augmenting path is found starting from 'matchedU'
                        pairV[v] = u; // Match v with u,
                        pairU[u] = v; // and u with v
                        return true;
                    }
                }
            }

            // No augmenting path was found starting from vertex u through any of its neighbours v,
            // so remove u from the depth first search phase of the algorithm
            levels[u] = INFINITY;
            return false;
        }

        return true;
    }

    private List<List<int>> adjacencyLists; // adjacencyLists(u) stores a list of neighbours of u in V
    private List<int> pairU; // pairU(u) stores the vertex v in V matched with u in U, or NIL if unmatched
    private List<int> pairV; // pairV(v) stores the vertex u in U matched with v in V, or NIL if unmatched
    private List<int> levels; // levels(u) stores the level of vertex u in U during a breadth first search

    private readonly int m; // Index of the vertices in the left partition
    private readonly int n; // Index of the vertices in the right partition

    private const int NIL = 0;
    private const int INFINITY = int.MaxValue;
}
