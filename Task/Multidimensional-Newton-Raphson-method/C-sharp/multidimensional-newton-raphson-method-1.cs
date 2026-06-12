using System;

namespace Rosetta
{
    internal interface IFun
    {
        double F(int index, Vector x);
        double df(int index, int derivative, Vector x);
        double[] weights();
    }

    class Newton
    {
        internal Vector Do(int size, IFun fun, Vector start)
        {
            Vector X = start.Clone();
            Vector F = new Vector(size);
            Matrix J = new Matrix(size, size);
            Vector D;
            do
            {
                for (int i = 0; i < size; i++)
                    F[i] = fun.F(i, X);
                for (int i = 0; i < size; i++)
                    for (int j = 0; j < size; j++)
                        J[i, j] = fun.df(i, j, X);
                J.ElimPartial(F);
                X -= F;
                //need weight vector because different coordinates can diffs by order of magnitudes
            } while (F.norm(fun.weights()) > 1e-12);
            return X;
        }
    }
}
