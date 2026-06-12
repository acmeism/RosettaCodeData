using System;
using System.Collections.Generic;
using System.Linq;

namespace ChristofidesAlgorithm
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var data = new List<Pair>
            {
                new Pair(1380, 939), new Pair(2848, 96), new Pair(3510, 1671), new Pair(457, 334), new Pair(3888, 666),
                new Pair(984, 965), new Pair(2721, 1482), new Pair(1286, 525), new Pair(2716, 1432), new Pair(738, 1325),
                new Pair(1251, 1832), new Pair(2728, 1698), new Pair(3815, 169), new Pair(3683, 1533), new Pair(1247, 1945),
                new Pair(123, 862), new Pair(1234, 1946), new Pair(252, 1240), new Pair(611, 673), new Pair(2576, 1676),
                new Pair(928, 1700), new Pair(53, 857), new Pair(1807, 1711), new Pair(274, 1420), new Pair(2574, 946),
                new Pair(178, 24), new Pair(2678, 1825), new Pair(1795, 962), new Pair(3384, 1498), new Pair(3520, 1079),
                new Pair(1256, 61), new Pair(1424, 1728), new Pair(3913, 192), new Pair(3085, 1528), new Pair(2573, 1969),
                new Pair(463, 1670), new Pair(3875, 598), new Pair(298, 1513), new Pair(3479, 821), new Pair(2542, 236),
                new Pair(3955, 1743), new Pair(1323, 280), new Pair(3447, 1830), new Pair(2936, 337), new Pair(1621, 1830),
                new Pair(3373, 1646), new Pair(1393, 1368), new Pair(3874, 1318), new Pair(938, 955), new Pair(3022, 474),
                new Pair(2482, 1183), new Pair(3854, 923), new Pair(376, 825), new Pair(2519, 135), new Pair(2945, 1622),
                new Pair(953, 268), new Pair(2628, 1479), new Pair(2097, 981), new Pair(890, 1846), new Pair(2139, 1806),
                new Pair(2421, 1007), new Pair(2290, 1810), new Pair(1115, 1052), new Pair(2588, 302), new Pair(327, 265),
                new Pair(241, 341), new Pair(1917, 687), new Pair(2991, 792), new Pair(2573, 599), new Pair(19, 674),
                new Pair(3911, 1673), new Pair(872, 1559), new Pair(2863, 558), new Pair(929, 1766), new Pair(839, 620),
                new Pair(3893, 102), new Pair(2178, 1619), new Pair(3822, 899), new Pair(378, 1048), new Pair(1178, 100),
                new Pair(2599, 901), new Pair(3416, 143), new Pair(2961, 1605), new Pair(611, 1384), new Pair(3113, 885),
                new Pair(2597, 1830), new Pair(2586, 1286), new Pair(161, 906), new Pair(1429, 134), new Pair(742, 1025),
                new Pair(1625, 1651), new Pair(1187, 706), new Pair(1787, 1009), new Pair(22, 987), new Pair(3640, 43),
                new Pair(3756, 882), new Pair(776, 392), new Pair(1724, 1642), new Pair(198, 1810), new Pair(3950, 1558)
            };

            var points = data.Select((pair, index) => new Point(pair, index)).ToList();

            ChristofidesPath(points);
        }

        // Display and return an approximation to the optimum travelling salesman path using the Christofides algorithm
        private static Result ChristofidesPath(List<Point> points)
        {
            if (!points.Any())
            {
                return new Result(new List<int>(), 0.0);
            }
            if (points.Count == 1)
            {
                return new Result(new List<int> { points.First().Id }, 0.0);
            }

            var graph = new Graph(points);
            graph.Display();

            var minimumSpanningTree = graph.MinimumSpanningTree();
            Console.WriteLine($"Minimum spanning tree: {string.Join(", ", minimumSpanningTree)}\n");

            var oddVertices = graph.OddVertices(minimumSpanningTree);
            Console.WriteLine($"Odd vertices in minimum spanning tree: [{string.Join(", ", oddVertices)}]\n");

            var minimumWeightMatching = graph.MinimumWeightMatching(minimumSpanningTree, oddVertices);
            Console.WriteLine($"Minimum weight matching: {string.Join(", ", minimumWeightMatching)}\n");

            var eulerianCircuit = graph.EulerianCircuit(minimumWeightMatching);
            Console.WriteLine($"Eulerian circuit: [{string.Join(", ", eulerianCircuit)}]\n");

            if (!eulerianCircuit.Any())
            {
                Console.Error.WriteLine("Error: Christofides path could not be found.");
                return new Result(new List<int>(), -1.0);
            }

            var result = graph.HamiltonianCircuit(eulerianCircuit);
            Console.WriteLine($"Result path: [{string.Join(", ", result.Path)}]\n");
            Console.WriteLine($"Length of the result path: {result.Length:F2}");

            return result;
        }
    }

    public record Pair(double X, double Y);
    public record Point(Pair Pair, int Id);
    public record Edge(int U, int V, double Weight)
    {
        public override string ToString()
        {
            return $"({U}, {V}, {Weight:F2})";
        }
    }

    public class Graph
    {
        private readonly List<List<double>> distanceLists;
        private readonly int pointCount;

        public Graph(List<Point> points)
        {
            pointCount = points.Count;
            distanceLists = Enumerable.Range(0, pointCount)
                .Select(i => Enumerable.Repeat(0.0, pointCount).ToList())
                .ToList();

            Func<Point, Point, double> distance = (one, two) =>
                Math.Sqrt(Math.Pow(one.Pair.X - two.Pair.X, 2) + Math.Pow(one.Pair.Y - two.Pair.Y, 2));

            for (int i = 0; i < pointCount; i++)
            {
                for (int j = i + 1; j < pointCount; j++)
                {
                    double dist = distance(points[i], points[j]);
                    distanceLists[i][j] = dist;
                    distanceLists[j][i] = dist;
                }
            }
        }

        // Return the minimum spanning tree using Kruskal's algorithm
        public List<Edge> MinimumSpanningTree()
        {
            var edges = new List<Edge>();
            if (pointCount == 0)
            {
                return edges;
            }

            for (int i = 0; i < pointCount; i++)
            {
                for (int j = i + 1; j < pointCount; j++) // Avoids duplicates and self-loops
                {
                    edges.Add(new Edge(i, j, distanceLists[i][j]));
                }
            }

            // Sort edges by weight
            edges.Sort((e1, e2) => e1.Weight.CompareTo(e2.Weight));

            var minimumSpanningTree = new List<Edge>();
            var unionFind = new UnionFind(pointCount);
            int edgeCount = 0;

            foreach (var edge in edges)
            {
                if (unionFind.Unite(edge.U, edge.V))
                {
                    minimumSpanningTree.Add(edge);
                    edgeCount++;
                    if (edgeCount == pointCount - 1)
                    {
                        break; // An optimization, since the minimum spanning tree has n - 1 edges
                    }
                }
            }

            return minimumSpanningTree;
        }

        // Return a list of vertices with odd degree in the minimum spanning tree
        public List<int> OddVertices(List<Edge> minimumSpanningTree)
        {
            var degrees = Enumerable.Repeat(0, pointCount).ToList();
            foreach (var edge in minimumSpanningTree)
            {
                degrees[edge.U]++;
                degrees[edge.V]++;
            }

            return Enumerable.Range(0, pointCount).Where(i => degrees[i] % 2 == 1).ToList();
        }

        // Return a minimum weight matching using a greedy heuristic
        public List<Edge> MinimumWeightMatching(List<Edge> minimumSpanningTree, List<int> oddVertices)
        {
            var minimumWeightMatching = new List<Edge>();
            if (!oddVertices.Any())
            {
                return minimumWeightMatching;
            }

            // All elements of 'minimumSpanningTree' are included
            minimumWeightMatching.AddRange(minimumSpanningTree);

            // Create a copy to prevent mutation of the argument 'oddVertices'
            var currentOdd = new List<int>(oddVertices);

            // Shuffle for randomness
            var random = new Random();
            for (int i = currentOdd.Count - 1; i > 0; i--)
            {
                int j = random.Next(i + 1);
                (currentOdd[i], currentOdd[j]) = (currentOdd[j], currentOdd[i]);
            }

            // Maintain a record of the visited indices in the shuffled 'currentOdd' list
            var visited = new HashSet<int>();

            for (int i = 0; i < currentOdd.Count; i++)
            {
                if (visited.Contains(i)) // Omit a vertex which has already been processed
                {
                    continue;
                }

                int v = currentOdd[i];
                double minimumDistance = double.MaxValue;
                int? closestUIndex = null;

                // Find the closest unmatched odd vertex occurring after 'v' in the shuffled 'currentOdd' list
                for (int j = i + 1; j < currentOdd.Count; j++)
                {
                    if (!visited.Contains(j)) // Check whether a vertex is available
                    {
                        int u = currentOdd[j];
                        if (distanceLists[v][u] < minimumDistance)
                        {
                            minimumDistance = distanceLists[v][u];
                            closestUIndex = j;
                        }
                    }
                }

                if (closestUIndex.HasValue)
                {
                    int j = closestUIndex.Value;
                    int u = currentOdd[j];
                    minimumWeightMatching.Add(new Edge(v, u, minimumDistance));

                    visited.Add(i); // Mark both vertices as processed
                    visited.Add(j);
                }
                else
                {
                    // This should not happen in the Christofides algorithm
                    // as the number of odd vertices is always even.
                    // If it does, it might indicate an issue with the input data
                    // or a graph where matching is not possible.
                    throw new InvalidOperationException($"Could not match an odd vertex in minimum weight matching: {v}");
                }
            }

            return minimumWeightMatching;
        }

        // Return a list of vertices forming an Eulerian circuit using Hierholzer's algorithm
        public List<int> EulerianCircuit(List<Edge> minimumWeightMatching)
        {
            var circuit = new List<int>();
            if (!minimumWeightMatching.Any())
            {
                return circuit;
            }

            // Create adjacency lists for the argument 'minimumWeightMatching'
            var adjacencyLists = Enumerable.Range(0, pointCount)
                .Select(i => new List<Twin>())
                .ToList();

            for (int index = 0; index < minimumWeightMatching.Count; index++)
            {
                var edge = minimumWeightMatching[index];
                adjacencyLists[edge.U].Add(new Twin(edge.V, index));
                adjacencyLists[edge.V].Add(new Twin(edge.U, index));
            }

            var edgesUsed = new HashSet<int>();
            var stack = new Stack<int>();

            // Start from any vertex having edges.
            // A suitable vertex is guaranteed to exist if 'minimumSpanningTree' is not empty
            int currentVertex = minimumWeightMatching.First().U;
            stack.Push(currentVertex);

            while (stack.Any())
            {
                currentVertex = stack.Peek();
                bool foundEdge = false;
                // Attempt to find an unused edge from the current vertex
                while (adjacencyLists[currentVertex].Any())
                {
                    var twin = adjacencyLists[currentVertex].Last();
                    adjacencyLists[currentVertex].RemoveAt(adjacencyLists[currentVertex].Count - 1);
                    if (!edgesUsed.Contains(twin.Index))
                    {
                        edgesUsed.Add(twin.Index);
                        stack.Push(twin.HalfEdge);
                        foundEdge = true;
                        break; // Move to the next vertex which is 'twin.HalfEdge'
                    }
                }

                // If no unused edge was found from 'currentVertex',
                // either the adjacency list was empty or all its edges have been used
                if (!foundEdge)
                {
                    circuit.Add(stack.Pop()); // Backtrack
                }
            }

            circuit.Reverse(); // The circuit has been constructed in reverse order
            return circuit;
        }

        public Result HamiltonianCircuit(List<int> eulerianCircuit)
        {
            // Create a Hamiltonian circuit by removing any repeated visits to the same vertex
            var christofidesPath = new List<int>();
            double length = 0.0;
            var visited = new HashSet<int>();

            int current = eulerianCircuit.First();
            christofidesPath.Add(current);
            visited.Add(current);

            foreach (int vertex in eulerianCircuit)
            {
                if (!visited.Contains(vertex))
                {
                    christofidesPath.Add(vertex);
                    visited.Add(vertex);
                    length += distanceLists[current][vertex]; // Add distance from previous vertex in path
                    current = vertex; // Update current vertex in path
                }
            }

            // Add the edge returning to the start vertex
            length += distanceLists[current][christofidesPath.First()];
            christofidesPath.Add(christofidesPath.First()); // Complete the cycle
            return new Result(christofidesPath, length);
        }

        public void Display()
        {
            Console.WriteLine("Graph: {");
            for (int u = 0; u < pointCount; u++)
            {
                Console.Write($"{u,3}: {{");
                bool first = true;
                for (int v = 0; v < pointCount; v++)
                {
                    if (u != v)
                    {
                        if (!first)
                        {
                            Console.Write(", ");
                        }
                        Console.Write($"{v}: {distanceLists[u][v]:F2}");
                        first = false;
                    }
                }
                Console.WriteLine("}" + (u == pointCount - 1 ? "" : ","));
            }
            Console.WriteLine("}\n");
        }

        private record Twin(int HalfEdge, int Index);

        private class UnionFind
        {
            private readonly List<int> parents;
            private readonly List<int> ranks;

            public UnionFind(int number)
            {
                parents = Enumerable.Range(0, number).ToList();
                ranks = Enumerable.Repeat(0, number).ToList();
            }

            public int Find(int n)
            {
                if (parents[n] == n)
                {
                    return n;
                }

                // Path compression
                parents[n] = Find(parents[n]);
                return parents[n];
            }

            public bool Unite(int i, int j)
            {
                int rootI = Find(i);
                int rootJ = Find(j);

                if (rootI != rootJ)
                {
                    int comparison = ranks[rootI].CompareTo(ranks[rootJ]);
                    switch (comparison)
                    {
                        case -1:
                            parents[rootI] = rootJ;
                            break;
                        case 1:
                            parents[rootJ] = rootI;
                            break;
                        case 0:
                            parents[rootJ] = rootI;
                            ranks[rootI]++;
                            break;
                    }
                    return true;
                }
                return false;
            }
        }
    }

    public record Result(List<int> Path, double Length);
}
