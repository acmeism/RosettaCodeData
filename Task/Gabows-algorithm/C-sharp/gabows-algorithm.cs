using System;
using System.Collections.Generic;
using System.Linq;

public sealed class GabowsAlgorithm
{
    public static void Main(string[] args)
    {
        var edges = new List<Edge>
        {
            new Edge(4, 2), new Edge(2, 3), new Edge(3, 2), new Edge(6, 0), new Edge(0, 1),
            new Edge(2, 0), new Edge(11, 12), new Edge(12, 9), new Edge(9, 10), new Edge(9, 11),
            new Edge(8, 9), new Edge(10, 12), new Edge(0, 5), new Edge(5, 4), new Edge(3, 5),
            new Edge(6, 4), new Edge(6, 9), new Edge(7, 6), new Edge(7, 8), new Edge(8, 7),
            new Edge(5, 3), new Edge(0, 6)
        };

        Digraph digraph = new Digraph(13);
        edges.ForEach(edge => digraph.AddEdge(edge.From, edge.To));

        Console.WriteLine("Constructed digraph:");
        Console.WriteLine(digraph);

        GabowSCC gabowSCC = new GabowSCC(digraph);
        Console.WriteLine($"It has {gabowSCC.StronglyConnectedComponentCount} strongly connected components.");

        List<List<int>> components = gabowSCC.Components();
        Console.WriteLine("\nComponents:");
        for (int i = 0; i < components.Count; i++)
        {
            Console.WriteLine($"Component {i}: {string.Join(" ", components[i])}");
        }

        Console.WriteLine("\nExample connectivity checks:");
        Console.WriteLine($"Vertices 0 and 3 strongly connected? {gabowSCC.IsStronglyConnected(0, 3)}");
        Console.WriteLine($"Vertices 0 and 7 strongly connected? {gabowSCC.IsStronglyConnected(0, 7)}");
        Console.WriteLine($"Vertices 9 and 12 strongly connected? {gabowSCC.IsStronglyConnected(9, 12)}");
        Console.WriteLine($"Component ID of vertex 5: {gabowSCC.ComponentID(5)}");
        Console.WriteLine($"Component ID of vertex 8: {gabowSCC.ComponentID(8)}");
    }
}

public struct Edge
{
    public int From { get; }
    public int To { get; }

    public Edge(int from, int to)
    {
        From = from;
        To = to;
    }
}


public sealed class GabowSCC
{
    private const int NONE = -1;
    private readonly List<bool> visited;
    private readonly List<int> componentIDs;
    private readonly List<int> preorders;
    private int preorderCount;
    private int sccCount;
    private readonly Stack<int> visitedVerticesStack;
    private readonly Stack<int> auxiliaryStack;

    public GabowSCC(Digraph digraph)
    {
        visited = Enumerable.Repeat(false, digraph.VertexCount).ToList();
        componentIDs = Enumerable.Repeat(NONE, digraph.VertexCount).ToList();
        preorders = Enumerable.Repeat(NONE, digraph.VertexCount).ToList();
        preorderCount = 0;
        sccCount = 0;
        visitedVerticesStack = new Stack<int>();
        auxiliaryStack = new Stack<int>();

        for (int vertex = 0; vertex < digraph.VertexCount; vertex++)
        {
            if (!visited[vertex])
                DepthFirstSearch(digraph, vertex);
        }
    }

    public List<List<int>> Components()
    {
        List<List<int>> components = Enumerable.Range(0, sccCount)
            .Select(_ => new List<int>()).ToList();

        for (int vertex = 0; vertex < visited.Count; vertex++)
        {
            int componentID = componentIDs[vertex];
            if (componentID != NONE)
                components[componentID].Add(vertex);
            else
                throw new Exception($"Vertex {vertex} has no SCC ID assigned.");
        }
        return components;
    }

    public bool IsStronglyConnected(int v, int w)
    {
        ValidateVertex(v);
        ValidateVertex(w);
        return componentIDs[v] != NONE && componentIDs[v] == componentIDs[w];
    }

    public int ComponentID(int vertex)
    {
        ValidateVertex(vertex);
        return componentIDs[vertex];
    }

    public int StronglyConnectedComponentCount => sccCount;

    private void DepthFirstSearch(Digraph digraph, int vertex)
    {
        visited[vertex] = true;
        preorders[vertex] = preorderCount++;
        visitedVerticesStack.Push(vertex);
        auxiliaryStack.Push(vertex);

        foreach (int w in digraph.AdjacencyList(vertex))
        {
            if (!visited[w])
            {
                DepthFirstSearch(digraph, w);
            }
            else if (componentIDs[w] == NONE)
            {
                while (auxiliaryStack.Count > 0 &&
                       preorders[auxiliaryStack.Peek()] > preorders[w])
                {
                    auxiliaryStack.Pop();
                }
            }
        }

        if (auxiliaryStack.Count > 0 && auxiliaryStack.Peek() == vertex)
        {
            auxiliaryStack.Pop();
            while (true)
            {
                int w = visitedVerticesStack.Pop();
                componentIDs[w] = sccCount;
                if (w == vertex) break;
            }
            sccCount++;
        }
    }

    private void ValidateVertex(int vertex)
    {
        if (vertex < 0 || vertex >= visited.Count)
            throw new ArgumentException($"Vertex {vertex} not in range [0, {visited.Count - 1}]");
    }
}

public sealed class Digraph
{
    public int VertexCount { get; }
    public int EdgeCount { get; private set; }
    private readonly List<List<int>> adjacencyLists;

    public Digraph(int vertexCount)
    {
        if (vertexCount < 0)
            throw new ArgumentException("Number of vertices must be non-negative");

        VertexCount = vertexCount;
        EdgeCount = 0;
        adjacencyLists = new List<List<int>>(vertexCount);
        for (int i = 0; i < vertexCount; i++)
            adjacencyLists.Add(new List<int>());
    }

    public void AddEdge(int from, int to)
    {
        ValidateVertex(from);
        ValidateVertex(to);
        adjacencyLists[from].Add(to);
        EdgeCount++;
    }

    public List<int> AdjacencyList(int vertex)
    {
        ValidateVertex(vertex);
        return adjacencyLists[vertex];
    }

    public override string ToString()
    {
        string result = $"Digraph has {VertexCount} vertices and {EdgeCount} edges\nAdjacency lists:\n";
        for (int vertex = 0; vertex < VertexCount; vertex++)
        {
            string adjacency = string.Join(" ", adjacencyLists[vertex].OrderBy(x => x));
            result += $"{vertex,2}: {adjacency}\n";
        }
        return result;
    }

    private void ValidateVertex(int vertex)
    {
        if (vertex < 0 || vertex >= VertexCount)
            throw new ArgumentException($"Vertex must be between 0 and {VertexCount - 1}: {vertex}");
    }
}
