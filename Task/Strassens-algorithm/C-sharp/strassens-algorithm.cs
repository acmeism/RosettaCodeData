using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

class Matrix
{
    public List<List<double>> data;
    public int rows;
    public int cols;

    public Matrix(List<List<double>> data)
    {
        this.data = data;
        rows = data.Count;
        cols = (rows > 0) ? data[0].Count : 0;
    }

    public int GetRows()
    {
        return rows;
    }

    public int GetCols()
    {
        return cols;
    }

    public void ValidateDimensions(Matrix other)
    {
        if (GetRows() != other.GetRows() || GetCols() != other.GetCols())
        {
            throw new InvalidOperationException("Matrices must have the same dimensions.");
        }
    }

    public void ValidateMultiplication(Matrix other)
    {
        if (GetCols() != other.GetRows())
        {
            throw new InvalidOperationException("Cannot multiply these matrices.");
        }
    }

    public void ValidateSquarePowerOfTwo()
    {
        if (GetRows() != GetCols())
        {
            throw new InvalidOperationException("Matrix must be square.");
        }
        if (GetRows() == 0 || (GetRows() & (GetRows() - 1)) != 0)
        {
            throw new InvalidOperationException("Size of matrix must be a power of two.");
        }
    }

    public static Matrix operator +(Matrix a, Matrix b)
    {
        a.ValidateDimensions(b);

        List<List<double>> resultData = new List<List<double>>();
        for (int i = 0; i < a.rows; ++i)
        {
            List<double> row = new List<double>();
            for (int j = 0; j < a.cols; ++j)
            {
                row.Add(a.data[i][j] + b.data[i][j]);
            }
            resultData.Add(row);
        }

        return new Matrix(resultData);
    }

    public static Matrix operator -(Matrix a, Matrix b)
    {
        a.ValidateDimensions(b);

        List<List<double>> resultData = new List<List<double>>();
        for (int i = 0; i < a.rows; ++i)
        {
            List<double> row = new List<double>();
            for (int j = 0; j < a.cols; ++j)
            {
                row.Add(a.data[i][j] - b.data[i][j]);
            }
            resultData.Add(row);
        }

        return new Matrix(resultData);
    }

    public static Matrix operator *(Matrix a, Matrix b)
    {
        a.ValidateMultiplication(b);

        List<List<double>> resultData = new List<List<double>>();
        for (int i = 0; i < a.rows; ++i)
        {
            List<double> row = new List<double>();
            for (int j = 0; j < b.cols; ++j)
            {
                double sum = 0.0;
                for (int k = 0; k < b.rows; ++k)
                {
                    sum += a.data[i][k] * b.data[k][j];
                }
                row.Add(sum);
            }
            resultData.Add(row);
        }

        return new Matrix(resultData);
    }

    public override string ToString()
    {
        StringBuilder sb = new StringBuilder();
        foreach (var row in data)
        {
            sb.Append("[");
            for (int i = 0; i < row.Count; ++i)
            {
                sb.Append(row[i]);
                if (i < row.Count - 1)
                {
                    sb.Append(", ");
                }
            }
            sb.AppendLine("]");
        }
        return sb.ToString();
    }

    public string ToStringWithPrecision(int p)
    {
        StringBuilder sb = new StringBuilder();
        double pow = Math.Pow(10.0, p);

        foreach (var row in data)
        {
            sb.Append("[");
            for (int i = 0; i < row.Count; ++i)
            {
                double r = Math.Round(row[i] * pow) / pow;
                string formatted = r.ToString($"F{p}");

                if (formatted == "-0" + (p > 0 ? "." + new string('0', p) : ""))
                {
                    formatted = "0" + (p > 0 ? "." + new string('0', p) : "");
                }

                sb.Append(formatted);

                if (i < row.Count - 1)
                {
                    sb.Append(", ");
                }
            }
            sb.AppendLine("]");
        }
        return sb.ToString();
    }

    private static int[,] GetParams(int r, int c)
    {
        return new int[,]
        {
            {0, r, 0, c, 0, 0},
            {0, r, c, 2 * c, 0, c},
            {r, 2 * r, 0, c, r, 0},
            {r, 2 * r, c, 2 * c, r, c}
        };
    }

    public Matrix[] ToQuarters()
    {
        int r = GetRows() / 2;
        int c = GetCols() / 2;
        int[,] p = GetParams(r, c);
        Matrix[] quarters = new Matrix[4];

        for (int k = 0; k < 4; ++k)
        {
            List<List<double>> qData = new List<List<double>>();
            for (int i = 0; i < r; i++)
            {
                List<double> row = new List<double>();
                for (int j = 0; j < c; j++)
                {
                    row.Add(0.0);
                }
                qData.Add(row);
            }

            for (int i = p[k, 0]; i < p[k, 1]; ++i)
            {
                for (int j = p[k, 2]; j < p[k, 3]; ++j)
                {
                    qData[i - p[k, 4]][j - p[k, 5]] = data[i][j];
                }
            }
            quarters[k] = new Matrix(qData);
        }

        return quarters;
    }

    public static Matrix FromQuarters(Matrix[] q)
    {
        int r = q[0].GetRows();
        int c = q[0].GetCols();
        int[,] p = GetParams(r, c);
        int rows = r * 2;
        int cols = c * 2;

        List<List<double>> mData = new List<List<double>>();
        for (int i = 0; i < rows; i++)
        {
            List<double> row = new List<double>();
            for (int j = 0; j < cols; j++)
            {
                row.Add(0.0);
            }
            mData.Add(row);
        }

        for (int k = 0; k < 4; ++k)
        {
            for (int i = p[k, 0]; i < p[k, 1]; ++i)
            {
                for (int j = p[k, 2]; j < p[k, 3]; ++j)
                {
                    mData[i][j] = q[k].data[i - p[k, 4]][j - p[k, 5]];
                }
            }
        }

        return new Matrix(mData);
    }

    public Matrix Strassen(Matrix other)
    {
        ValidateSquarePowerOfTwo();
        other.ValidateSquarePowerOfTwo();
        if (GetRows() != other.GetRows() || GetCols() != other.GetCols())
        {
            throw new InvalidOperationException("Matrices must be square and of equal size for Strassen multiplication.");
        }

        if (GetRows() == 1)
        {
            return this * other;
        }

        Matrix[] qa = ToQuarters();
        Matrix[] qb = other.ToQuarters();

        Matrix p1 = (qa[1] - qa[3]).Strassen(qb[2] + qb[3]);
        Matrix p2 = (qa[0] + qa[3]).Strassen(qb[0] + qb[3]);
        Matrix p3 = (qa[0] - qa[2]).Strassen(qb[0] + qb[1]);
        Matrix p4 = (qa[0] + qa[1]).Strassen(qb[3]);
        Matrix p5 = qa[0].Strassen(qb[1] - qb[3]);
        Matrix p6 = qa[3].Strassen(qb[2] - qb[0]);
        Matrix p7 = (qa[2] + qa[3]).Strassen(qb[0]);

        Matrix[] q = new Matrix[4];

        q[0] = p1 + p2 - p4 + p6;
        q[1] = p4 + p5;
        q[2] = p6 + p7;
        q[3] = p2 - p3 + p5 - p7;

        return FromQuarters(q);
    }
}

class Program
{
    static void Main(string[] args)
    {
        Matrix a = new Matrix(new List<List<double>> { new List<double> { 1.0, 2.0 }, new List<double> { 3.0, 4.0 } });
        Matrix b = new Matrix(new List<List<double>> { new List<double> { 5.0, 6.0 }, new List<double> { 7.0, 8.0 } });
        Matrix c = new Matrix(new List<List<double>>
        {
            new List<double> { 1.0, 1.0, 1.0, 1.0 },
            new List<double> { 2.0, 4.0, 8.0, 16.0 },
            new List<double> { 3.0, 9.0, 27.0, 81.0 },
            new List<double> { 4.0, 16.0, 64.0, 256.0 }
        });
        Matrix d = new Matrix(new List<List<double>>
        {
            new List<double> { 4.0, -3.0, 4.0 / 3.0, -1.0 / 4.0 },
            new List<double> { -13.0 / 3.0, 19.0 / 4.0, -7.0 / 3.0, 11.0 / 24.0 },
            new List<double> { 3.0 / 2.0, -2.0, 7.0 / 6.0, -1.0 / 4.0 },
            new List<double> { -1.0 / 6.0, 1.0 / 4.0, -1.0 / 6.0, 1.0 / 24.0 }
        });
        Matrix e = new Matrix(new List<List<double>>
        {
            new List<double> { 1.0, 2.0, 3.0, 4.0 },
            new List<double> { 5.0, 6.0, 7.0, 8.0 },
            new List<double> { 9.0, 10.0, 11.0, 12.0 },
            new List<double> { 13.0, 14.0, 15.0, 16.0 }
        });
        Matrix f = new Matrix(new List<List<double>>
        {
            new List<double> { 1.0, 0.0, 0.0, 0.0 },
            new List<double> { 0.0, 1.0, 0.0, 0.0 },
            new List<double> { 0.0, 0.0, 1.0, 0.0 },
            new List<double> { 0.0, 0.0, 0.0, 1.0 }
        });

        Console.WriteLine("Using 'normal' matrix multiplication:");
        Console.WriteLine($"  a * b = {a * b}");
        Console.WriteLine($"  c * d = {(c * d).ToStringWithPrecision(6)}");
        Console.WriteLine($"  e * f = {e * f}");

        Console.WriteLine("\nUsing 'Strassen' matrix multiplication:");
        Console.WriteLine($"  a * b = {a.Strassen(b)}");
        Console.WriteLine($"  c * d = {c.Strassen(d).ToStringWithPrecision(6)}");
        Console.WriteLine($"  e * f = {e.Strassen(f)}");
    }
}
