using System;
//Works in .NET 6+
//Tested using https://dotnetfiddle.net because im lazy

public class Program {

    public static double[][] legeCoef(int N) {
        //Initialising Jagged Array
        double[][] lcoef = new double[N+1][];
        for (int i=0; i < lcoef.Length; ++i)
            lcoef[i] = new double[N+1];


        lcoef[0][0] = lcoef[1][1] = 1;
        for (int n = 2; n <= N; n++) {
            lcoef[n][0] = -(n - 1) * lcoef[n - 2][0] / n;
            for (int i = 1; i <= n; i++)
                lcoef[n][i] = ((2*n - 1) * lcoef[n-1][i-1]
                               - (n-1) * lcoef[n-2][i] ) / n;
        }
        return lcoef;
    }


    static double legeEval(double[][] lcoef, int N, double x) {
        double s = lcoef[N][N];
        for (int i = N; i > 0; --i)
            s = s * x + lcoef[N][i-1];
        return s;
    }

    static double legeDiff(double[][] lcoef, int N, double x) {
        return N * (x * legeEval(lcoef, N, x) - legeEval(lcoef, N-1, x)) / (x*x - 1);
    }

    static void legeRoots(double[][] lcoef, int N, out double[] lroots,  out double[] weight) {
        lroots = new double[N];
        weight = new double[N];

        double x, x1;
        for (int i = 1; i <= N; i++) {
            x = Math.Cos(Math.PI * (i - 0.25) / (N + 0.5));
            do {
                x1 = x;
                x -= legeEval(lcoef, N, x) / legeDiff(lcoef, N, x);
            }
            while (x != x1);
            lroots[i-1] = x;

            x1 = legeDiff(lcoef, N, x);
            weight[i-1] = 2 / ((1 - x*x) * x1*x1);
        }
    }



    static double legeInte(Func<Double, Double> f, int N, double[] weights, double[] lroots, double a, double b) {
        double c1 = (b - a) / 2, c2 = (b + a) / 2, sum = 0;
        for (int i = 0; i < N; i++)
            sum += weights[i] * f.Invoke(c1 * lroots[i] + c2);
        return c1 * sum;
    }

    //..................Main...............................
    public static string Combine(double[] arrayD) {
        return string.Join(", ", arrayD);	
    }

    public static void Main() {
        int N = 5;

        var lcoeff = legeCoef(N);

        double[] roots;
        double[] weights;
        legeRoots(lcoeff, N, out roots, out weights);

        var integrateResult = legeInte(x=>Math.Exp(x), N, weights, roots, -3, 3);

        Console.WriteLine("Roots:   " + Combine(roots));
        Console.WriteLine("Weights: " + Combine(weights)+ "\n" );
        Console.WriteLine("integral: " + integrateResult );
        Console.WriteLine("actual:   " + (Math.Exp(3)-Math.Exp(-3)) );
    }


}
