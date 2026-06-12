using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class BerlekampMasseyTask
{
    public static void Main(string[] args)
    {
        var source = new List<int> { 0, 1, 1, 2, 3, 5, 8, 13, 21 };
        var bm = new BerlekampMassey(source, 100);
        var bmCoeffs = bm.ComputeCoefficients();

        Console.WriteLine($"Berlekamp-Massey coefficients: [{string.Join(", ", bmCoeffs)}] (lowest to highest degree)");
        Console.WriteLine($"The connection polynomial is {bm.Polynomial(bmCoeffs)} having degree {bmCoeffs.Count - 1}\n");

        Console.WriteLine("Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:");
        // Result can be checked on www.oeis.net, A000045
        var indices = new[] { 35, 36, 37, 38, 39, 40 };
        var terms = indices.Select(n => bm.ComputeTerm(bmCoeffs, n)).ToArray();
        Console.WriteLine(string.Join(" ", terms));
    }
}

public class BerlekampMassey
{
    private readonly List<int> source;
    private readonly int modulus;

    public BerlekampMassey(List<int> source, int modulus)
    {
        this.source = new List<int>(source);
        this.modulus = modulus;
    }

    public List<int> ComputeCoefficients()
    {
        var result = new List<int>();
        var previousResult = new List<int>();
        int failIndex = -1;

        for (int i = 0; i < source.Count; i++)
        {
            int delta = source[i];
            for (int j = 1; j <= result.Count; j++)
            {
                delta -= result[j - 1] * source[i - j];
            }

            if (delta == 0)
            {
                continue;
            }

            if (failIndex == -1)
            {
                result = Enumerable.Repeat(0, i + 1).ToList();
                failIndex = i;
            }
            else
            {
                var previousResultCopy = new List<int> { 1 };
                foreach (int term in previousResult)
                {
                    previousResultCopy.Add(-term);
                }

                int termFailIndexPlusOne = 0;
                for (int j = 1; j <= previousResultCopy.Count; j++)
                {
                    termFailIndexPlusOne += previousResultCopy[j - 1] * source[failIndex + 1 - j];
                }

                int coeff = delta / termFailIndexPlusOne;
                for (int k = 0; k < previousResultCopy.Count; k++)
                {
                    previousResultCopy[k] = previousResultCopy[k] * coeff;
                }

                for (int k = 0; k < i - failIndex - 1; k++)
                {
                    previousResultCopy.Insert(0, 0);
                }

                var resultCopy = new List<int>(result);
                while (result.Count < previousResultCopy.Count)
                {
                    result.Add(0);
                }

                for (int j = 0; j < previousResultCopy.Count; j++)
                {
                    result[j] = result[j] + previousResultCopy[j];
                }

                if (i - resultCopy.Count > failIndex - previousResult.Count)
                {
                    previousResult = new List<int>(resultCopy);
                    failIndex = i;
                }
            }
        }
        return result;
    }

    public int ComputeTerm(List<int> bmCoeffs, int index)
    {
        if (bmCoeffs.Count == 0)
        {
            return 0;
        }

        if (index < source.Count)
        {
            return (source[index] + modulus) % modulus;
        }

        var coeffs = new List<int> { modulus - 1 };
        coeffs.AddRange(bmCoeffs);

        int bmCoeffsSize = bmCoeffs.Count;
        var f = Enumerable.Repeat(0, bmCoeffsSize).ToList();
        var g = Enumerable.Repeat(0, bmCoeffsSize).ToList();

        f[0] = 1;

        if (bmCoeffsSize == 1)
        {
            g[0] = coeffs[1];
        }
        else
        {
            g[1] = 1;
        }

        int power = index - 1;
        while (power > 0)
        {
            if ((power & 1) == 1)
            {
                f = PolynomialMultiply(f, g, bmCoeffsSize, coeffs);
            }
            g = PolynomialMultiply(g, g, bmCoeffsSize, coeffs);
            power >>= 1;
        }

        int result = 0;
        for (int i = 0; i < bmCoeffsSize; i++)
        {
            if (i + 1 < source.Count)
            {
                result = (result + source[i + 1] * f[i]) % modulus;
            }
        }
        return (result + modulus) % modulus;
    }

    public string Polynomial(List<int> bmCoeffs)
    {
        int degree = bmCoeffs.Count - 1;
        if (degree == 0)
        {
            return bmCoeffs[0].ToString();
        }

        var text = new StringBuilder();
        for (int i = degree; i >= 0; i--)
        {
            int coeff = bmCoeffs[i];
            if (coeff == 0)
            {
                continue;
            }

            string sign = (coeff < 0 && i == degree) ?
                "-" : (coeff < 0) ? " - " : (i < degree) ? " + " : "";
            text.Append(sign);

            int coeffAbs = Math.Abs(coeff);
            if (coeffAbs > 1)
            {
                text.Append(coeffAbs);
            }

            string term = (i > 1) ? $"x^{i}" : (i == 1) ?
                "x" : (coeffAbs == 1) ? "1" : "";
            text.Append(term);
        }
        return text.ToString();
    }

    private List<int> PolynomialMultiply(List<int> a, List<int> b, int degree, List<int> coeffs)
    {
        var result = Enumerable.Repeat(0, 2 * degree).ToList();

        for (int i = 0; i < degree; i++)
        {
            if (a[i] == 0)
            {
                continue;
            }
            for (int j = 0; j < degree; j++)
            {
                result[i + j] = (result[i + j] + a[i] * b[j]) % modulus;
            }
        }

        for (int i = 2 * degree - 1; i > degree - 1; i--)
        {
            if (result[i] == 0)
            {
                continue;
            }

            int term = result[i];
            result[i] = 0;

            for (int j = 0; j <= degree; j++)
            {
                int index = i - j;
                if (index >= 0)
                {
                    result[index] = (result[index] + term * coeffs[j]) % modulus;
                }
            }
        }
        return result.GetRange(0, degree);
    }
}
