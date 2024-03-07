using System;

class RayCasting {

    static bool Intersects(int[] A, int[] B, double[] P) {
        if (A[1] > B[1])
            return Intersects(B, A, P);

        if (P[1] == A[1] || P[1] == B[1])
            P[1] += 0.0001;

        if (P[1] > B[1] || P[1] < A[1] || P[0] >= Math.Max(A[0], B[0]))
            return false;

        if (P[0] < Math.Min(A[0], B[0]))
            return true;

        double red = (P[1] - A[1]) / (P[0] - A[0]);
        double blue = (B[1] - A[1]) / (B[0] - A[0]);
        return red >= blue;
    }

    static bool Contains(int[][] shape, double[] pnt) {
        bool inside = false;
        int len = shape.Length;
        for (int i = 0; i < len; i++) {
            if (Intersects(shape[i], shape[(i + 1) % len], pnt))
                inside = !inside;
        }
        return inside;
    }

    public static void Main(string[] args) {
        double[][] testPoints = new double[][] {
            new double[] { 10, 10 }, new double[] { 10, 16 }, new double[] { -20, 10 },
            new double[] { 0, 10 }, new double[] { 20, 10 }, new double[] { 16, 10 },
            new double[] { 20, 20 }
        };

        foreach (int[][] shape in shapes) {
            foreach (double[] pnt in testPoints)
                Console.Write($"{Contains(shape, pnt),7} ");
            Console.WriteLine();
        }
    }

    readonly static int[][] square = new int[][] {
        new int[] { 0, 0 }, new int[] { 20, 0 }, new int[] { 20, 20 }, new int[] { 0, 20 }
    };

    readonly static int[][] squareHole = new int[][] {
        new int[] { 0, 0 }, new int[] { 20, 0 }, new int[] { 20, 20 }, new int[] { 0, 20 },
        new int[] { 5, 5 }, new int[] { 15, 5 }, new int[] { 15, 15 }, new int[] { 5, 15 }
    };

    readonly static int[][] strange = new int[][] {
        new int[] { 0, 0 }, new int[] { 5, 5 }, new int[] { 0, 20 }, new int[] { 5, 15 },
        new int[] { 15, 15 }, new int[] { 20, 20 }, new int[] { 20, 0 }
    };

    readonly static int[][] hexagon = new int[][] {
        new int[] { 6, 0 }, new int[] { 14, 0 }, new int[] { 20, 10 }, new int[] { 14, 20 },
        new int[] { 6, 20 }, new int[] { 0, 10 }
    };

    readonly static int[][][] shapes = new int[][][] { square, squareHole, strange, hexagon };
}
