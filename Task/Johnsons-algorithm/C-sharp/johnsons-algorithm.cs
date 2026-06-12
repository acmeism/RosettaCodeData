using System;
using System.Collections.Generic;
using System.Linq;

public class JohnsonsAlgorithm
{
    private const double INF = double.MaxValue;

    public static void Main(string[] args)
    {
        // The element (i, j) is the weight of the edge from vertex i to vertex j.
        // INF, for infinity, means that there is no edge from vertex i to vertex j.
        List<List<double>> graph = new List<List<double>> {
            new List<double> { 0.0, -5.0, 2.0, 3.0 },
            new List<double> { INF, 0.0, 4.0, INF },
            new List<double> { INF, INF, 0.0, 1.0 },
            new List<double> { INF, INF, INF, 0.0 }
        };

        var result = JohnsonsAlgorithmRunner(graph);

        if (result != null)
        {
            Console.WriteLine("All pairs shortest paths:");
            Console.WriteLine("The element (i, j) is the shortest path between vertex i and vertex j.");
            foreach (var row in result)
            {
                Console.Write("[");
                foreach (var number in row)
                {
                    Console.Write((number == INF) ? "INF " : number + " ");
                }
                Console.WriteLine("]");
            }
        }
        else
        {
            Console.WriteLine("A negative cycle was detected in the graph.");
        }
    }

    private static List<List<double>> JohnsonsAlgorithmRunner(List<List<double>> graph)
    {
        int vertexCount = graph.Count;
        List<Edge> originalEdges = new List<Edge>();

        // Step 0: Build a list of edges for the original graph
        for (int i = 0; i < vertexCount; i++)
        {
            for (int j = 0; j < vertexCount; j++)
            {
                double weight = graph[i][j];
                if (i == j)
                {
                    if (weight != 0.0)
                    {
                        Console.WriteLine($"Warning: graph[i][i] for i = {i} is {weight}, expected to be 0.0, resetting it to 0.0");
                    }
                }
                else if (weight != INF)
                {
                    originalEdges.Add(new Edge(i, j, weight));
                }
            }
        }

        // Step 1: Form the augmented graph
        List<Edge> augmentedEdges = new List<Edge>(originalEdges);
        for (int i = 0; i < vertexCount; i++)
        {
            augmentedEdges.Add(new Edge(vertexCount, i, 0.0));
        }

        // Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
        var hValues = BellmanFordAlgorithm(vertexCount + 1, augmentedEdges, vertexCount);

        if (hValues == null)
        {
            return null; // A negative cycle was detected by the Bellman-Ford Algorithm
        }

        List<double> values = hValues;
        values.RemoveAt(values.Count - 1); // Remove the value for the augmented vertex

        // Step 3: Reweight the edges
        Dictionary<int, List<VertexAndWeight>> reweightedAdjacencies = Enumerable.Range(0, vertexCount).ToDictionary(v => v, v => new List<VertexAndWeight>());

        foreach (var edge in originalEdges)
        {
            if (values[edge.U] == INF || values[edge.V] == INF)
            {
                Console.WriteLine("Warning: invalid hValues detected by the Bellman-Ford Algorithm.");
            }
            double reweight = edge.Weight + values[edge.U] - values[edge.V];
            reweightedAdjacencies[edge.U].Add(new VertexAndWeight(edge.V, reweight));
        }

        // Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
        List<List<double>> allPairsShortestPaths = Enumerable.Range(0, vertexCount).Select(u => DijkstraAlgorithm(vertexCount, reweightedAdjacencies, u, values)).ToList();

        // Step 5: Return the result matrix
        return allPairsShortestPaths;
    }

    private static List<double> BellmanFordAlgorithm(int augmentedVertexCount, List<Edge> edges, int sourceVertex)
    {
        List<double> distances = Enumerable.Repeat(INF, augmentedVertexCount).ToList();
        distances[sourceVertex] = 0.0;

        // Relax the edges (augmentedVertexCount - 1) times
        bool updated = true;
        for (int i = 0; i < augmentedVertexCount - 1 && updated; i++)
        {
            updated = false;
            foreach (var edge in edges)
            {
                if (distances[edge.U] != INF && distances[edge.U] + edge.Weight < distances[edge.V])
                {
                    distances[edge.V] = distances[edge.U] + edge.Weight;
                    updated = true;
                }
            }
        }

        // Check for negative cycles in the graph
        foreach (var edge in edges)
        {
            if (distances[edge.U] != INF && distances[edge.U] + edge.Weight < distances[edge.V])
            {
                return null; // Indicates to the calling method that a negative cycle has been detected
            }
        }
        return distances;
    }

    private static List<double> DijkstraAlgorithm(int vertexCount, Dictionary<int, List<VertexAndWeight>> reweightedAdjacencies, int sourceVertex, List<double> values)
    {
        List<double> distances = Enumerable.Repeat(INF, vertexCount).ToList();
        distances[sourceVertex] = 0.0;

        var priorityQueue = new PriorityQueue<VertexAndWeight>();
        priorityQueue.Enqueue(new VertexAndWeight(sourceVertex, 0.0));

        List<double> finalDistances = Enumerable.Repeat(INF, vertexCount).ToList();

        while (priorityQueue.Count > 0)
        {
            VertexAndWeight vertexAndWeight = priorityQueue.Dequeue();
            int vertex = vertexAndWeight.Vertex;
            if (vertexAndWeight.Weight > distances[vertex])
            {
                continue;
            }

            if (finalDistances[vertex] == INF)
            {
                if (distances[vertex] == INF)
                {
                    finalDistances[vertex] = INF;
                }
                else
                {
                    finalDistances[vertex] = distances[vertex] - values[sourceVertex] + values[vertex];
                }
            }

            if (reweightedAdjacencies.ContainsKey(vertex))
            {
                foreach (var pair in reweightedAdjacencies[vertex])
                {
                    if (distances[vertex] != INF && distances[vertex] + pair.Weight < distances[pair.Vertex])
                    {
                        distances[pair.Vertex] = distances[vertex] + pair.Weight;
                        priorityQueue.Enqueue(new VertexAndWeight(pair.Vertex, distances[pair.Vertex]));
                    }
                }
            }
        }

        for (int i = 0; i < vertexCount; i++)
        {
            if (finalDistances[i] == INF && distances[i] != INF)
            {
                finalDistances[i] = distances[i] - values[sourceVertex] + values[i];
            }
        }

        return finalDistances;
    }

    private class Edge
    {
        public int U { get; }
        public int V { get; }
        public double Weight { get; }

        public Edge(int u, int v, double weight)
        {
            U = u;
            V = v;
            Weight = weight;
        }
    }

    private class VertexAndWeight : IComparable<VertexAndWeight>
    {
        public int Vertex { get; }
        public double Weight { get; }

        public VertexAndWeight(int vertex, double weight)
        {
            Vertex = vertex;
            Weight = weight;
        }

        public int CompareTo(VertexAndWeight other)
        {
            return Weight.CompareTo(other.Weight);
        }
    }

    private class PriorityQueue<T> where T : IComparable<T>
    {
        private List<T> data;

        public PriorityQueue()
        {
            this.data = new List<T>();
        }

        public void Enqueue(T item)
        {
            data.Add(item);
            int childIndex = data.Count - 1;
            while (childIndex > 0)
            {
                int parentIndex = (childIndex - 1) / 2;
                if (data[childIndex].CompareTo(data[parentIndex]) >= 0)
                    break;
                T tmp = data[childIndex];
                data[childIndex] = data[parentIndex];
                data[parentIndex] = tmp;
                childIndex = parentIndex;
            }
        }

        public T Dequeue()
        {
            int lastIndex = data.Count - 1;
            T frontItem = data[0];
            data[0] = data[lastIndex];
            data.RemoveAt(lastIndex);

            lastIndex--;
            int parentIndex = 0;
            while (true)
            {
                int childIndex = parentIndex * 2 + 1;
                if (childIndex > lastIndex)
                    break;
                int rightChild = childIndex + 1;
                if (rightChild <= lastIndex && data[rightChild].CompareTo(data[childIndex]) < 0)
                    childIndex = rightChild;
                if (data[parentIndex].CompareTo(data[childIndex]) <= 0)
                    break;
                T tmp = data[parentIndex];
                data[parentIndex] = data[childIndex];
                data[childIndex] = tmp;
                parentIndex = childIndex;
            }

            return frontItem;
        }

        public int Count => data.Count;
    }
}

