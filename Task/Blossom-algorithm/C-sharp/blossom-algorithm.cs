using System;
using System.Collections.Generic;
using System.Linq;

public class BlossomAlgorithm
{
    private int n;
    private List<List<int>> adj;
    private int[] match, p, baseArray;
    private bool[] used, blossom;
    private Queue<int> queue;

    public BlossomAlgorithm(List<List<int>> adj)
    {
        this.n = adj.Count;
        this.adj = adj;
        this.match = new int[n];
        this.p = new int[n];
        this.baseArray = new int[n];
        this.used = new bool[n];
        this.blossom = new bool[n];
        this.queue = new Queue<int>();

        for (int i = 0; i < n; i++)
        {
            match[i] = -1;
        }
    }

    // Find least common ancestor of a and b in the alternating forest
    private int Lca(int a, int b)
    {
        bool[] usedPath = new bool[n];
        while (true)
        {
            a = baseArray[a];
            usedPath[a] = true;
            if (match[a] < 0) break;
            a = p[match[a]];
        }
        while (true)
        {
            b = baseArray[b];
            if (usedPath[b]) return b;
            b = p[match[b]];
        }
    }

    // Mark vertices along the path from v to base b, setting their parent to x
    private void MarkPath(int v, int b, int x)
    {
        while (baseArray[v] != b)
        {
            int mv = match[v];
            blossom[baseArray[v]] = true;
            blossom[baseArray[mv]] = true;
            p[v] = x;
            x = mv;
            v = p[x];
        }
    }

    // Try to find an augmenting path starting from root
    private bool FindPath(int root)
    {
        Array.Fill(used, false);
        Array.Fill(p, -1);
        for (int i = 0; i < n; i++)
        {
            baseArray[i] = i;
        }
        queue.Clear();

        used[root] = true;
        queue.Enqueue(root);

        while (queue.Count > 0)
        {
            int v = queue.Dequeue();
            foreach (int u in adj[v])
            {
                if (baseArray[v] == baseArray[u] || match[v] == u)
                {
                    continue;
                }
                // Blossom found
                if (u == root || (match[u] >= 0 && p[match[u]] >= 0))
                {
                    int curbase = Lca(v, u);
                    Array.Fill(blossom, false);
                    MarkPath(v, curbase, u);
                    MarkPath(u, curbase, v);
                    for (int i = 0; i < n; i++)
                    {
                        if (blossom[baseArray[i]])
                        {
                            baseArray[i] = curbase;
                            if (!used[i])
                            {
                                used[i] = true;
                                queue.Enqueue(i);
                            }
                        }
                    }
                }
                else if (p[u] < 0)
                {
                    // Extend the alternating tree
                    p[u] = v;
                    // Found augmenting path
                    if (match[u] < 0)
                    {
                        int cur = u;
                        while (cur >= 0)
                        {
                            int prev = p[cur];
                            int next = (prev >= 0 ? match[prev] : -1);
                            match[cur] = prev;
                            match[prev] = cur;
                            cur = next;
                        }
                        return true;
                    }
                    // Continue BFS from the matched partner
                    int mu = match[u];
                    if (!used[mu])
                    {
                        used[mu] = true;
                        queue.Enqueue(mu);
                    }
                }
            }
        }
        return false;
    }

    // Compute maximum matching; returns the size
    public int Solve()
    {
        int res = 0;
        for (int v = 0; v < n; v++)
        {
            if (match[v] < 0)
            {
                if (FindPath(v))
                {
                    res++;
                }
            }
        }
        return res;
    }

    public int[] GetMatch()
    {
        return match;
    }

    public static void Main(string[] args)
    {
        // Example: 5‑cycle (odd cycle) 0--1--2--3--4--0
        int n = 5;
        int[][] edges = { new[] {0,1}, new[] {1,2}, new[] {2,3}, new[] {3,4}, new[] {4,0} };
        List<List<int>> adj = new List<List<int>>();
        for (int i = 0; i < n; i++)
        {
            adj.Add(new List<int>());
        }
        foreach (int[] e in edges)
        {
            adj[e[0]].Add(e[1]);
            adj[e[1]].Add(e[0]);
        }

        BlossomAlgorithm blossom = new BlossomAlgorithm(adj);
        int msize = blossom.Solve();
        int[] match = blossom.GetMatch();

        Console.WriteLine("Maximum matching size: " + msize);
        Console.WriteLine("Matched pairs:");
        for (int u = 0; u < n; u++)
        {
            int v = match[u];
            if (v >= 0 && u < v)
            {
                Console.WriteLine("  " + u + " -- " + v);
            }
        }
    }
}
