using System;
using System.Collections.Generic;

class Node
{
    public int LowLink { get; set; }
    public int Index { get; set; }
    public int N { get; }

    public Node(int n)
    {
        N = n;
        Index = -1;
        LowLink = 0;
    }
}

class Graph
{
    public HashSet<Node> V { get; }
    public Dictionary<Node, HashSet<Node>> Adj { get; }

    /// <summary>
    /// Tarjan's strongly connected components algorithm
    /// </summary>
    public void Tarjan()
    {
        var index = 0; // number of nodes
        var S = new Stack<Node>();

        Action<Node> StrongConnect = null;
        StrongConnect = (v) =>
        {
            // Set the depth index for v to the smallest unused index
            v.Index = index;
            v.LowLink = index;

            index++;
            S.Push(v);

            // Consider successors of v
            foreach (var w in Adj[v])
                if (w.Index < 0)
                {
                    // Successor w has not yet been visited; recurse on it
                    StrongConnect(w);
                    v.LowLink = Math.Min(v.LowLink, w.LowLink);
                }
                else if (S.Contains(w))
                    // Successor w is in stack S and hence in the current SCC
                    v.LowLink = Math.Min(v.LowLink, w.Index);

            // If v is a root node, pop the stack and generate an SCC
            if (v.LowLink == v.Index)
            {
                Console.Write("SCC: ");

                Node w;
                do
                {
                    w = S.Pop();
                    Console.Write(w.N + " ");
                } while (w != v);

                Console.WriteLine();
            }
        };

        foreach (var v in V)
            if (v.Index < 0)
                StrongConnect(v);
    }
}
