using System;

class MatrixChainOrderOptimizer {
    private int[,] m;
    private int[,] s;

    void OptimalMatrixChainOrder(int[] dims) {
        int n = dims.Length - 1;
        m = new int[n, n];
        s = new int[n, n];
        for (int len = 1; len < n; ++len) {
            for (int i = 0; i < n - len; ++i) {
                int j = i + len;
                m[i, j] = Int32.MaxValue;
                for (int k = i; k < j; ++k) {
                    int temp = dims[i] * dims[k + 1] * dims[j + 1];
                    int cost = m[i, k] + m[k + 1, j] + temp;
                    if (cost < m[i, j]) {
                        m[i, j] = cost;
                        s[i, j] = k;
                    }
                }
            }
        }
    }

    void PrintOptimalChainOrder(int i, int j) {
        if (i == j)
            Console.Write((char)(i + 65));
        else {
            Console.Write("(");
            PrintOptimalChainOrder(i, s[i, j]);
            PrintOptimalChainOrder(s[i, j] + 1, j);
            Console.Write(")");
        }
    }

    static void Main() {
        var mcoo = new MatrixChainOrderOptimizer();
        var dimsList = new int[3][];
        dimsList[0] = new int[4] {5, 6, 3, 1};
        dimsList[1] = new int[13] {1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2};
        dimsList[2] = new int[12] {1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10};
        for (int i = 0; i < dimsList.Length; ++i) {
            Console.Write("Dims  : [");
            int n = dimsList[i].Length;
            for (int j = 0; j < n; ++j) {
                Console.Write(dimsList[i][j]);
                if (j < n - 1)
                    Console.Write(", ");
                else
                    Console.WriteLine("]");
            }
            mcoo.OptimalMatrixChainOrder(dimsList[i]);
            Console.Write("Order : ");
            mcoo.PrintOptimalChainOrder(0, n - 2);
            Console.WriteLine("\nCost  : {0}\n",  mcoo.m[0, n - 2]);
        }
    }
}
