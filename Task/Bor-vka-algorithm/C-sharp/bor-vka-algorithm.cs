using System;
using System.Collections.Generic;
using System.Linq;

public record Edge(int U, int V, double Weight);

public sealed class BoruvkaAlgorithm
{
    public static void Main(string[] args)
    {
        Graph graph = new Graph(4);
        graph.AddEdge(new Edge(0, 1, 10.0));
        graph.AddEdge(new Edge(0, 2, 6.0));
        graph.AddEdge(new Edge(0, 3, 5.0));
        graph.AddEdge(new Edge(1, 3, 15.0));
        graph.AddEdge(new Edge(2, 3, 4.0));

        graph.BoruvkaMinimumSpanningTree();
    }
}

sealed class Graph
{
    public Graph(int vertexCount)
    {
        this.vertexCount = vertexCount;
        edges = new List<Edge>();
    }

    public void AddEdge(Edge edge)
    {
        edges.Add(edge);
    }

    // Return the minimum spanning tree by using Boruvka's algorithm
    public void BoruvkaMinimumSpanningTree()
    {
        List<int> parent = Enumerable.Range(0, vertexCount).ToList();
        List<int> rank = Enumerable.Repeat(0, vertexCount).ToList();

        // Store the indexes of the cheapest edge of each tree
        List<Edge> cheapest = Enumerable.Range(0, vertexCount)
            .Select(i => new Edge(-1, -1, -1.0)).ToList();

        // Initially there are 'vertexCount' different trees
        int treeCount = vertexCount;
        int minimumSpanningTreeWeight = 0;

        // Combine trees until all trees are combined into a single minimum spanning tree
        while (treeCount > 1)
        {
            // Traverse through all edges and update cheapest edge for every tree
            foreach (Edge edge in edges)
            {
                int u = edge.U;
                int v = edge.V;
                double weight = edge.Weight;

                int index1 = Find(parent, u);
                int index2 = Find(parent, v);

                // If the two vertices of the current edge belong to different trees,
                // check whether the current edge is cheaper than previous cheapest edges
                if (index1 != index2)
                {
                    if (cheapest[index1].Weight == -1.0 || cheapest[index1].Weight > weight)
                    {
                        cheapest[index1] = new Edge(u, v, weight);
                    }
                    if (cheapest[index2].Weight == -1.0 || cheapest[index2].Weight > weight)
                    {
                        cheapest[index2] = new Edge(u, v, weight);
                    }
                }
            }

            // Add the cheapest edges to the minimum spanning tree
            for (int vertex = 0; vertex < vertexCount; vertex++)
            {
                // Check whether the cheapest edge for current vertex exists
                if (cheapest[vertex].Weight != -1.0)
                {
                    int u = cheapest[vertex].U;
                    int v = cheapest[vertex].V;
                    double weight = cheapest[vertex].Weight;

                    int index1 = Find(parent, u);
                    int index2 = Find(parent, v);

                    if (index1 != index2)
                    {
                        minimumSpanningTreeWeight += (int)weight;
                        UnionSet(parent, rank, index1, index2);
                        Console.WriteLine($"Edge {u}--{v} with weight {weight} is included in the minimum spanning tree");
                        treeCount -= 1;
                    }
                }
            }
        }

        Console.WriteLine($"\nWeight of minimum spanning tree is {minimumSpanningTreeWeight}");
    }

    // Return the index of the tree containing 'vertex', using a path compression technique
    private int Find(List<int> parent, int vertex)
    {
        if (parent[vertex] != vertex)
        {
            parent[vertex] = Find(parent, parent[vertex]);
        }

        return parent[vertex];
    }

    // Form the union by rank of the two trees indexed by u and v
    private void UnionSet(List<int> parent, List<int> rank, int u, int v)
    {
        int uRoot = Find(parent, u);
        int vRoot = Find(parent, v);

        // Attach the smaller rank tree under root of the high rank tree
        int comparison = rank[uRoot].CompareTo(rank[vRoot]);

        if (comparison < 0)
        {
            parent[uRoot] = vRoot;
        }
        else if (comparison > 0)
        {
            parent[vRoot] = uRoot;
        }
        else
        {
            // If ranks are the same, make one the root and increment its rank
            parent[vRoot] = uRoot;
            rank[uRoot] = rank[uRoot] + 1;
        }
    }

    private List<Edge> edges;
    private readonly int vertexCount;
}
