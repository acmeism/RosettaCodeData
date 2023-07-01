        static void Main(string[] args)
        {
            const int degree = 2;
            var x = new[] {0.0, 1.0,  2.0,  3.0,  4.0,  5.0,   6.0,   7.0,   8.0,   9.0,  10.0};
            var y = new[] {1.0, 6.0, 17.0, 34.0, 57.0, 86.0, 121.0, 162.0, 209.0, 262.0, 321.0};
            var p = Polyfit(x, y, degree);
            foreach (var d in p) Console.Write("{0} ",d);
            Console.WriteLine();
            for (int i = 0; i < x.Length; i++ )
                Console.WriteLine("{0} => {1} diff {2}", x[i], Polynomial.Evaluate(x[i], p), y[i] - Polynomial.Evaluate(x[i], p));
            Console.ReadKey(true);
        }
