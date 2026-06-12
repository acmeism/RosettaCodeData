using System;

//example from https://eti.pg.edu.pl/documents/176593/26763380/Wykl_AlgorOblicz_7.pdf
namespace Rosetta
{
    class Program
    {
        class Fun: IFun
        {
            private double[] w = new double[] { 1,1 };

            public double F(int index, Vector x)
            {
                switch (index)
                {
                    case 0: return Math.Atan(x[0]) - x[1] * x[1] * x[1];
                    case 1: return 4 * x[0] * x[0] + 9 * x[1] * x[1] - 36;
                }
                throw new Exception("bad index");
            }

            public double df(int index, int derivative, Vector x)
            {
                switch (index)
                {
                    case 0:
                        switch (derivative)
                        {
                            case 0: return 1 / (1 + x[0] * x[0]);
                            case 1: return -3*x[1]*x[1];
                        }
                        break;
                    case 1:
                        switch (derivative)
                        {
                            case 0: return 8 * x[0];
                            case 1: return 18 * x[1];
                        }
                        break;
                }
                throw new Exception("bad index");
            }
            public double[] weights() { return w; }
        }

        static void Main(string[] args)
        {
            Fun fun = new Fun();
            Newton newton = new Newton();
            Vector start = new Vector(new double[] { 2.75, 1.25 });
            Vector X = newton.Do(2, fun, start);
            X.print();
        }
    }
}
