using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace HamiltonianCycleViaChvatalClosure
{
    class Program
    {
        static void Main(string[] args)
        {
            // Example: An almost complete graph with 5 vertices and missing the edge 0--1.
            // This graph satisfies Ore's condition, since degree(0)=3, degree(1)=3 and 3+3>=5.
            int vertexCount = 5;
            var graph = new Graph(vertexCount);

            // Add all edges except 0--1
            for (int u = 0; u < vertexCount; u++)
            {
                for (int v = u + 1; v < vertexCount; v++)
                {
                    if (!(u == 0 && v == 1))
                        graph.AddEdge(u, v);
                }
            }

            Console.WriteLine("Original graph degrees:");
            for (int u = 0; u < vertexCount; u++)
            {
                Console.WriteLine($"    degree({u}) = {graph.Degree(u)}");
            }

            var closureGraph = new Graph(graph);
            closureGraph.Closure();

            Console.WriteLine("\nAfter Chvátal closure:");
            for (int u = 0; u < vertexCount; u++)
            {
                Console.Write($"    {u}: ");
                for (int v = 0; v < vertexCount; v++)
                {
                    if (closureGraph.GetAdjacencies()[u][v])
                        Console.Write(v + " ");
                }
                Console.WriteLine();
            }

            if (closureGraph.IsComplete())
            {
                Console.WriteLine("\nclosureGraph is complete => graph is Hamiltonian, by the Bondy–Chvátal theorem.");
                var cycle = graph.HamiltonianCycle();
                if (cycle.Count > 0)
                {
                    Console.WriteLine("Found Hamiltonian cycle in the original graph:");
                    Console.WriteLine(string.Join(" -> ", cycle));
                }
                else
                {
                    Console.WriteLine("Unable to find a Hamiltonian cycle.");
                }
            }
            else
            {
                Console.WriteLine("\nClosure is not complete => no guarantee of Hamiltonian cycle.");
            }
        }
    }

    public class Graph
    {
        private readonly int _vertexCount;
        private readonly List<BitArray> _adjacencies;

        public Graph(int vertexCount)
        {
            _vertexCount = vertexCount;
            _adjacencies = new List<BitArray>(vertexCount);
            for (int i = 0; i < vertexCount; i++)
                _adjacencies.Add(new BitArray(vertexCount));
        }

        public Graph(Graph other)
        {
            _vertexCount = other._vertexCount;
            _adjacencies = other._adjacencies
                                .Select(bs => (BitArray)bs.Clone())
                                .ToList();
        }

        // Add an undirected edge u--v
        public void AddEdge(int u, int v)
        {
            if (u < 0 || u >= _vertexCount || v < 0 || v >= _vertexCount)
                throw new ArgumentOutOfRangeException($"Edge endpoints out of range: {u}, {v}");

            _adjacencies[u][v] = true;
            _adjacencies[v][u] = true;
        }

        public List<BitArray> GetAdjacencies() => _adjacencies;

        // Return the degree of the given vertex
        public int Degree(int u)
        {
            if (u < 0 || u >= _vertexCount)
                throw new ArgumentOutOfRangeException($"Vertex out of range: {u}");

            int count = 0;
            var bits = _adjacencies[u];
            for (int i = 0; i < _vertexCount; i++)
                if (bits[i]) count++;
            return count;
        }

        // Compute the Chvátal closure in-place.
        // Repeatedly adds an edge u--v as long as (u,v) is missing and degree(u)+degree(v)>=vertexCount
        public void Closure()
        {
            bool added;
            do
            {
                added = false;
                for (int u = 0; u < _vertexCount && !added; u++)
                {
                    for (int v = u + 1; v < _vertexCount && !added; v++)
                    {
                        if (! _adjacencies[u][v] &&
                            Degree(u) + Degree(v) >= _vertexCount)
                        {
                            AddEdge(u, v);
                            added = true;
                        }
                    }
                }
            } while (added);
        }

        // Return whether the graph is complete
        public bool IsComplete()
        {
            for (int u = 0; u < _vertexCount; u++)
                for (int v = u + 1; v < _vertexCount; v++)
                    if (! _adjacencies[u][v])
                        return false;
            return true;
        }

        // Find a Hamiltonian cycle in the original graph by simple backtracking.
        // Returns a list of vertices including the return to the start vertex,
        // or an empty list if none is found.
        public List<int> HamiltonianCycle()
        {
            var path = new List<int> { 0 };
            var visited = new HashSet<int> { 0 };

            if (DepthFirstSearch(path, visited, 0))
            {
                path.Add(0);
                return path;
            }

            return new List<int>();
        }

        private bool DepthFirstSearch(List<int> path, HashSet<int> visited, int u)
        {
            if (path.Count == _vertexCount)
            {
                // Can we close the cycle?
                if (_adjacencies[u][path[0]])
                    return true;
                return false;
            }

            for (int v = 0; v < _vertexCount; v++)
            {
                if (!visited.Contains(v) && _adjacencies[u][v])
                {
                    visited.Add(v);
                    path.Add(v);

                    if (DepthFirstSearch(path, visited, v))
                        return true;

                    // backtrack
                    path.RemoveAt(path.Count - 1);
                    visited.Remove(v);
                }
            }

            return false;
        }
    }
}
