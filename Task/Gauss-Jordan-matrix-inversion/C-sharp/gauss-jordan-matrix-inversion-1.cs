using System;

namespace Rosetta
{
    internal class Vector
    {
        private double[] b;
        internal readonly int rows;

        internal Vector(int rows)
        {
            this.rows = rows;
            b = new double[rows];
        }

        internal Vector(double[] initArray)
        {
            b = (double[])initArray.Clone();
            rows = b.Length;
        }

        internal Vector Clone()
        {
            Vector v = new Vector(b);
            return v;
        }

        internal double this[int row]
        {
            get { return b[row]; }
            set { b[row] = value; }
        }

        internal void SwapRows(int r1, int r2)
        {
            if (r1 == r2) return;
            double tmp = b[r1];
            b[r1] = b[r2];
            b[r2] = tmp;
        }

        internal double norm(double[] weights)
        {
            double sum = 0;
            for (int i = 0; i < rows; i++)
            {
                double d = b[i] * weights[i];
                sum +=  d*d;
            }
            return Math.Sqrt(sum);
        }

        internal void print()
        {
            for (int i = 0; i < rows; i++)
                Console.WriteLine(b[i]);
            Console.WriteLine();
        }

        public static Vector operator-(Vector lhs, Vector rhs)
        {
            Vector v = new Vector(lhs.rows);
            for (int i = 0; i < lhs.rows; i++)
                v[i] = lhs[i] - rhs[i];
            return v;
        }
    }

    class Matrix
    {
        private double[] b;
        internal readonly int rows, cols;

        internal Matrix(int rows, int cols)
        {
            this.rows = rows;
            this.cols = cols;
            b = new double[rows * cols];
        }

        internal Matrix(int size)
        {
            this.rows = size;
            this.cols = size;
            b = new double[rows * cols];
            for (int i = 0; i < size; i++)
                this[i, i] = 1;
        }

        internal Matrix(int rows, int cols, double[] initArray)
        {
            this.rows = rows;
            this.cols = cols;
            b = (double[])initArray.Clone();
            if (b.Length != rows * cols) throw new Exception("bad init array");
        }

        internal double this[int row, int col]
        {
            get { return b[row * cols + col]; }
            set { b[row * cols + col] = value; }
        }

        public static Vector operator*(Matrix lhs, Vector rhs)
        {
            if (lhs.cols != rhs.rows) throw new Exception("I can't multiply matrix by vector");
            Vector v = new Vector(lhs.rows);
            for (int i = 0; i < lhs.rows; i++)
            {
                double sum = 0;
                for (int j = 0; j < rhs.rows; j++)
                    sum += lhs[i,j]*rhs[j];
                v[i] = sum;
            }
            return v;
        }

        internal void SwapRows(int r1, int r2)
        {
            if (r1 == r2) return;
            int firstR1 = r1 * cols;
            int firstR2 = r2 * cols;
            for (int i = 0; i < cols; i++)
            {
                double tmp = b[firstR1 + i];
                b[firstR1 + i] = b[firstR2 + i];
                b[firstR2 + i] = tmp;
            }
        }

        //with partial pivot
        internal bool InvPartial()
        {
            const double Eps = 1e-12;
            if (rows != cols) throw new Exception("rows != cols for Inv");
            Matrix M = new Matrix(rows); //unitary
            for (int diag = 0; diag < rows; diag++)
            {
                int max_row = diag;
                double max_val = Math.Abs(this[diag, diag]);
                double d;
                for (int row = diag + 1; row < rows; row++)
                    if ((d = Math.Abs(this[row, diag])) > max_val)
                    {
                        max_row = row;
                        max_val = d;
                    }
                if (max_val <= Eps) return false;
                SwapRows(diag, max_row);
                M.SwapRows(diag, max_row);
                double invd = 1 / this[diag, diag];
                for (int col = diag; col < cols; col++)
                {
                    this[diag, col] *= invd;
                }
                for (int col = 0; col < cols; col++)
                {
                    M[diag, col] *= invd;
                }
                for (int row = 0; row < rows; row++)
                {
                    d = this[row, diag];
                    if (row != diag)
                    {
                        for (int col = diag; col < this.cols; col++)
                        {
                            this[row, col] -= d * this[diag, col];
                        }
                        for (int col = 0; col < this.cols; col++)
                        {
                            M[row, col] -= d * M[diag, col];
                        }
                    }
                }
            }
            b = M.b;
            return true;
        }

        internal void print()
        {
            for (int i = 0; i < rows; i++)
            {
                for (int j = 0; j < cols; j++)
                    Console.Write(this[i,j].ToString()+"  ");
                Console.WriteLine();
            }
        }
    }
}
