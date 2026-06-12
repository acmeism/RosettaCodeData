using System;
using System.Collections.Generic;

class Program
{
    static Result Process(int N, int[] A)
    {
        int[] pi = new int[N + 1];
        int[] beta = new int[N + 1];
        int[] alfa = new int[N + 1];
        int[] tau = new int[N + 1];
        int[] lam = new int[N + 1];
        Node[] nodes = new Node[N + 1];
        for (int i = 0; i <= N; i++)
        {
            nodes[i] = new Node();
        }

        // Make triply linked tree
        int t = 0;
        for (int v = N; v > 0; v--)
        {
            int u = 0;
            while (A[v] > A[t] || (A[v] == A[t] && v > t))
            {
                u = t;
                t = nodes[t].Parent;
            }

            if (u != 0)
            {
                nodes[v].Sib = nodes[u].Sib;
                nodes[u].Sib = 0;
                nodes[u].Parent = v;
                nodes[v].Child = u;
            }
            else
            {
                nodes[v].Sib = nodes[t].Child;
            }

            nodes[t].Child = v;
            nodes[v].Parent = t;
            t = v;
        }

        // Begin first traversal
        int p = nodes[0].Child;
        int n = 0;
        lam[0] = -1;

        while (Traversal(nodes, p, n, pi, beta, tau, lam, out p, out n))
        {
            // Continue traversal
        }

        // Begin second traversal
        p = nodes[0].Child;
        lam[0] = lam[n];
        pi[0] = beta[0] = alfa[0] = 0;

        // Perform second traversal
        if (p != 0)
        {
            ComputeAlfa(nodes, p, alfa, beta);
        }

        return new Result(pi, beta, alfa, tau, lam);
    }

    static bool Traversal(Node[] nodes, int initialP, int initialN, int[] pi, int[] beta, int[] tau, int[] lam, out int newP, out int newN)
    {
        int p = initialP;
        int n = initialN;

        // s3: Compute beta in the easy case
        while (true)
        {
            n++;
            pi[p] = n;
            tau[n] = 0;
            lam[n] = 1 + lam[n >> 1];

            if (nodes[p].Child != 0)
            {
                p = nodes[p].Child;
                continue;
            }

            beta[p] = n;
            break;
        }

        // s4: Compute tau, bottom-up
        while (true)
        {
            tau[beta[p]] = nodes[p].Parent;

            if (nodes[p].Sib != 0)
            {
                p = nodes[p].Sib;
                newP = p;
                newN = n;
                return true;  // Go back to s3
            }

            p = nodes[p].Parent;

            // Compute beta in the hard case
            if (p != 0)
            {
                int h = lam[n & -pi[p]];
                beta[p] = ((n >> h) | 1) << h;
            }
            else
            {
                newP = p;
                newN = n;
                return false;  // Exit traversal
            }
        }
    }

    static void ComputeAlfa(Node[] nodes, int node, int[] alfa, int[] beta)
    {
        // s7: Compute alfa, top-down
        alfa[node] = alfa[nodes[node].Parent] | (beta[node] & -beta[node]);

        if (nodes[node].Child != 0)
        {
            ComputeAlfa(nodes, nodes[node].Child, alfa, beta);
        }

        // s8: Continue traversal
        if (nodes[node].Sib != 0)
        {
            ComputeAlfa(nodes, nodes[node].Sib, alfa, beta);
        }
    }

    static int Nca(int x, int y, int[] beta, int[] alfa, int[] tau, int[] lam, int[] pi)
    {
        // Find common height
        int h;
        if (beta[x] <= beta[y])
        {
            h = lam[beta[y] & -beta[x]];
        }
        else
        {
            h = lam[beta[x] & -beta[y]];
        }

        // Find true height
        int k = alfa[x] & alfa[y] & -(1 << h);
        h = lam[k & -k];

        // Find beta[z]
        int j = ((beta[x] >> h) | 1) << h;

        // Find x' and y'
        if (j != beta[x])
        {
            int l = lam[alfa[x] & ((1 << h) - 1)];
            x = tau[((beta[x] >> l) | 1) << l];
        }

        if (j != beta[y])
        {
            int l = lam[alfa[y] & ((1 << h) - 1)];
            y = tau[((beta[y] >> l) | 1) << l];
        }

        // Find z
        int z = (pi[x] <= pi[y]) ? x : y;
        return z;
    }

    static List<int> SolveTestCase(int n, int[] values, int[,] queries)
    {
        List<int> results = new List<int>();

        int[] A = new int[n + 2];
        A[0] = int.MaxValue;  // A[0]
        int[] R = new int[n + 2];
        int[] B = new int[n + 2];

        int N = 1;
        int count = 0;
        int? oldx = null;

        for (int i = 1; i <= n; i++)
        {
            int x = values[i - 1];

            if (i > 1 && (oldx == null || x != oldx))
            {
                A[N] = count;
                R[N] = i;
                N++;
                count = 0;
            }

            B[i] = N;
            count++;
            oldx = x;
        }

        A[N] = count;
        R[N] = n + 1;

        Result result = Process(N, A);
        int[] pi = result.Pi;
        int[] beta = result.Beta;
        int[] alfa = result.Alfa;
        int[] tau = result.Tau;
        int[] lam = result.Lam;

        int queryCount = queries.GetLength(0);
        for (int q = 0; q < queryCount; q++)
        {
            int i = queries[q, 0];
            int j = queries[q, 1];
            int x = B[i];
            int y = B[j];

            int z;
            if (x == y)
            {
                z = j - i + 1;
            }
            else
            {
                if (x + 1 != y)
                {
                    z = A[Nca(x + 1, y - 1, beta, alfa, tau, lam, pi)];
                }
                else
                {
                    z = 0;
                }

                z = Math.Max(z, Math.Max(R[x] - i, A[y] - R[y] + j + 1));
            }

            results.Add(z);
        }

        return results;
    }

    static void Main(string[] args)
    {
        // Hard-coded test data
        List<TestCase> testCases = new List<TestCase>();
        testCases.Add(new TestCase(
            10,
            new int[] { -1, -1, 1, 1, 1, 1, 3, 10, 10, 10 },
            new int[,] { { 2, 3 }, { 1, 10 }, { 5, 10 } },
            new int[] { 1, 4, 3 }
        ));

        for (int idx = 0; idx < testCases.Count; idx++)
        {
            TestCase test = testCases[idx];
            int n = test.N;
            int[] values = test.Values;
            int[,] queries = test.Queries;
            int[] expected = test.Expected;

            Console.WriteLine($"Test Case {idx + 1}:");
            Console.WriteLine($"Size: {n}, Queries: {queries.GetLength(0)}");
            Console.Write("Values: ");
            foreach (int value in values)
            {
                Console.Write($"{value} ");
            }
            Console.WriteLine();

            List<int> results = SolveTestCase(n, values, queries);

            Console.WriteLine("Queries and Results:");
            for (int q_idx = 0; q_idx < queries.GetLength(0); q_idx++)
            {
                int query0 = queries[q_idx, 0];
                int query1 = queries[q_idx, 1];
                int result = results[q_idx];
                int exp = expected[q_idx];

                Console.WriteLine($"Query: {query0} {query1}");
                Console.WriteLine($"Result: {result} (Expected: {exp})");
                if (result != exp)
                {
                    Console.WriteLine("  WARNING: Result doesn't match expected output");
                }
            }

            Console.WriteLine();
        }
    }
}

class Node
{
    public int Child { get; set; } = 0;
    public int Sib { get; set; } = 0;
    public int Parent { get; set; } = 0;
}

class Result
{
    public int[] Pi { get; }
    public int[] Beta { get; }
    public int[] Alfa { get; }
    public int[] Tau { get; }
    public int[] Lam { get; }

    public Result(int[] pi, int[] beta, int[] alfa, int[] tau, int[] lam)
    {
        Pi = pi;
        Beta = beta;
        Alfa = alfa;
        Tau = tau;
        Lam = lam;
    }
}

class TestCase
{
    public int N { get; }
    public int[] Values { get; }
    public int[,] Queries { get; }
    public int[] Expected { get; }

    public TestCase(int n, int[] values, int[,] queries, int[] expected)
    {
        N = n;
        Values = values;
        Queries = queries;
        Expected = expected;
    }
}
