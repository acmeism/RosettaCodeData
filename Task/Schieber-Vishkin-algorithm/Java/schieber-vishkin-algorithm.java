import java.util.*;

class Main {
    static Result process(int N, int[] A) {
        int[] pi = new int[N + 1];
        int[] beta = new int[N + 1];
        int[] alfa = new int[N + 1];
        int[] tau = new int[N + 1];
        int[] lam = new int[N + 1];
        Node[] nodes = new Node[N + 1];
        for (int i = 0; i <= N; i++) {
            nodes[i] = new Node();
        }

        // Make triply linked tree
        int t = 0;
        for (int v = N; v > 0; v--) {
            int u = 0;
            while (A[v] > A[t] || (A[v] == A[t] && v > t)) {
                u = t;
                t = nodes[t].parent;
            }

            if (u != 0) {
                nodes[v].sib = nodes[u].sib;
                nodes[u].sib = 0;
                nodes[u].parent = v;
                nodes[v].child = u;
            } else {
                nodes[v].sib = nodes[t].child;
            }

            nodes[t].child = v;
            nodes[v].parent = t;
            t = v;
        }

        // Begin first traversal
        int p = nodes[0].child;
        int n = 0;
        lam[0] = -1;

        while (traversal(nodes, p, n, pi, beta, tau, lam)) {
            // Continue traversal
            n = getN();
            p = getP();
        }

        // Begin second traversal
        p = nodes[0].child;
        lam[0] = lam[n];
        pi[0] = beta[0] = alfa[0] = 0;

        // Perform second traversal
        if (p != 0) {
            compute_alfa(nodes, p, alfa, beta);
        }

        return new Result(pi, beta, alfa, tau, lam);
    }

    // These static variables are used to simulate the nonlocal variables in Python
    private static int p;
    private static int n;

    private static int getP() {
        return p;
    }

    private static int getN() {
        return n;
    }

    static boolean traversal(Node[] nodes, int initialP, int initialN, int[] pi, int[] beta, int[] tau, int[] lam) {
        p = initialP;
        n = initialN;

        // s3: Compute beta in the easy case
        while (true) {
            n++;
            pi[p] = n;
            tau[n] = 0;
            lam[n] = 1 + lam[n >> 1];

            if (nodes[p].child != 0) {
                p = nodes[p].child;
                continue;
            }

            beta[p] = n;
            break;
        }

        // s4: Compute tau, bottom-up
        while (true) {
            tau[beta[p]] = nodes[p].parent;

            if (nodes[p].sib != 0) {
                p = nodes[p].sib;
                return true;  // Go back to s3
            }

            p = nodes[p].parent;

            // Compute beta in the hard case
            if (p != 0) {
                int h = lam[n & -pi[p]];
                beta[p] = ((n >> h) | 1) << h;
            } else {
                return false;  // Exit traversal
            }
        }
    }

    static void compute_alfa(Node[] nodes, int node, int[] alfa, int[] beta) {
        // s7: Compute alfa, top-down
        alfa[node] = alfa[nodes[node].parent] | (beta[node] & -beta[node]);

        if (nodes[node].child != 0) {
            compute_alfa(nodes, nodes[node].child, alfa, beta);
        }

        // s8: Continue traversal
        if (nodes[node].sib != 0) {
            compute_alfa(nodes, nodes[node].sib, alfa, beta);
        }
    }

    static int nca(int x, int y, int[] beta, int[] alfa, int[] tau, int[] lam, int[] pi) {
        // Find common height
        int h;
        if (beta[x] <= beta[y]) {
            h = lam[beta[y] & -beta[x]];
        } else {
            h = lam[beta[x] & -beta[y]];
        }

        // Find true height
        int k = alfa[x] & alfa[y] & -(1 << h);
        h = lam[k & -k];

        // Find beta[z]
        int j = ((beta[x] >> h) | 1) << h;

        // Find x' and y'
        if (j != beta[x]) {
            int l = lam[alfa[x] & ((1 << h) - 1)];
            x = tau[((beta[x] >> l) | 1) << l];
        }

        if (j != beta[y]) {
            int l = lam[alfa[y] & ((1 << h) - 1)];
            y = tau[((beta[y] >> l) | 1) << l];
        }

        // Find z
        int z = (pi[x] <= pi[y]) ? x : y;
        return z;
    }

    static List<Integer> solve_test_case(int n, int[] values, int[][] queries) {
        List<Integer> results = new ArrayList<>();

        int[] A = new int[n + 2];
        A[0] = Integer.MAX_VALUE;  // A[0]
        int[] R = new int[n + 2];
        int[] B = new int[n + 2];

        int N = 1;
        int count = 0;
        Integer oldx = null;

        for (int i = 1; i <= n; i++) {
            int x = values[i - 1];

            if (i > 1 && (oldx == null || x != oldx)) {
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

        Result result = process(N, A);
        int[] pi = result.pi;
        int[] beta = result.beta;
        int[] alfa = result.alfa;
        int[] tau = result.tau;
        int[] lam = result.lam;

        for (int[] query : queries) {
            int i = query[0];
            int j = query[1];
            int x = B[i];
            int y = B[j];

            int z;
            if (x == y) {
                z = j - i + 1;
            } else {
                if (x + 1 != y) {
                    z = A[nca(x + 1, y - 1, beta, alfa, tau, lam, pi)];
                } else {
                    z = 0;
                }

                z = Math.max(z, Math.max(R[x] - i, A[y] - R[y] + j + 1));
            }

            results.add(z);
        }

        return results;
    }

    public static void main(String[] args) {
        // Hard-coded test data
        List<TestCase> testCases = new ArrayList<>();
        testCases.add(new TestCase(
            10,
            new int[]{-1, -1, 1, 1, 1, 1, 3, 10, 10, 10},
            new int[][]{{2, 3}, {1, 10}, {5, 10}},
            new int[]{1, 4, 3}
        ));

        for (int idx = 0; idx < testCases.size(); idx++) {
            TestCase test = testCases.get(idx);
            int n = test.n;
            int[] values = test.values;
            int[][] queries = test.queries;
            int[] expected = test.expected;

            System.out.println("Test Case " + (idx + 1) + ":");
            System.out.println("Size: " + n + ", Queries: " + queries.length);
            System.out.print("Values: ");
            for (int value : values) {
                System.out.print(value + " ");
            }
            System.out.println();

            List<Integer> results = solve_test_case(n, values, queries);

            System.out.println("Queries and Results:");
            for (int q_idx = 0; q_idx < queries.length; q_idx++) {
                int[] query = queries[q_idx];
                int result = results.get(q_idx);
                int exp = expected[q_idx];

                System.out.println("Query: " + query[0] + " " + query[1]);
                System.out.println("Result: " + result + " (Expected: " + exp + ")");
                if (result != exp) {
                    System.out.println("  WARNING: Result doesn't match expected output");
                }
            }

            System.out.println();
        }
    }

    static class TestCase {
        int n;
        int[] values;
        int[][] queries;
        int[] expected;

        public TestCase(int n, int[] values, int[][] queries, int[] expected) {
            this.n = n;
            this.values = values;
            this.queries = queries;
            this.expected = expected;
        }
    }
}

class Node {
    int child = 0;
    int sib = 0;
    int parent = 0;
}

class Result {
    int[] pi;
    int[] beta;
    int[] alfa;
    int[] tau;
    int[] lam;

    public Result(int[] pi, int[] beta, int[] alfa, int[] tau, int[] lam) {
        this.pi = pi;
        this.beta = beta;
        this.alfa = alfa;
        this.tau = tau;
        this.lam = lam;
    }
}
