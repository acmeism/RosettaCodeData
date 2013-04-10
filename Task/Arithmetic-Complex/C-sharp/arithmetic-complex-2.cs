using System;

public struct ComplexNumber
{
    public static readonly ComplexNumber i = new ComplexNumber(0.0, 1.0);
    public static readonly ComplexNumber Zero = new ComplexNumber(0.0, 0.0);

    public double Re;
    public double Im;

    public ComplexNumber(double re)
    {
        this.Re = re;
        this.Im = 0;
    }

    public ComplexNumber(double re, double im)
    {
        this.Re = re;
        this.Im = im;
    }

    public static ComplexNumber operator *(ComplexNumber n1, ComplexNumber n2)
    {
        return new ComplexNumber(n1.Re * n2.Re - n1.Im * n2.Im,
            n1.Im * n2.Re + n1.Re * n2.Im);
    }

    public static ComplexNumber operator *(double n1, ComplexNumber n2)
    {
        return new ComplexNumber(n1 * n2.Re, n1 * n2.Im);
    }

    public static ComplexNumber operator /(ComplexNumber n1, ComplexNumber n2)
    {
        double n2Norm = n2.Re * n2.Re + n2.Im * n2.Im;
        return new ComplexNumber((n1.Re * n2.Re + n1.Im * n2.Im) / n2Norm,
            (n1.Im * n2.Re - n1.Re * n2.Im) / n2Norm);
    }

    public static ComplexNumber operator /(ComplexNumber n1, double n2)
    {
        return new ComplexNumber(n1.Re / n2, n1.Im / n2);
    }

    public static ComplexNumber operator +(ComplexNumber n1, ComplexNumber n2)
    {
        return new ComplexNumber(n1.Re + n2.Re, n1.Im + n2.Im);
    }

    public static ComplexNumber operator -(ComplexNumber n1, ComplexNumber n2)
    {
        return new ComplexNumber(n1.Re - n2.Re, n1.Im - n2.Im);
    }

    public static ComplexNumber operator -(ComplexNumber n)
    {
        return new ComplexNumber(-n.Re, -n.Im);
    }

    public static implicit operator ComplexNumber(double n)
    {
        return new ComplexNumber(n, 0.0);
    }

    public static explicit operator double(ComplexNumber n)
    {
        return n.Re;
    }

    public static bool operator ==(ComplexNumber n1, ComplexNumber n2)
    {
        return n1.Re == n2.Re && n1.Im == n2.Im;
    }

    public static bool operator !=(ComplexNumber n1, ComplexNumber n2)
    {
        return n1.Re != n2.Re || n1.Im != n2.Im;
    }

    public override bool Equals(object obj)
    {
        return this == (ComplexNumber)obj;
    }

    public override int GetHashCode()
    {
        return Re.GetHashCode() ^ Im.GetHashCode();
    }

    public override string ToString()
    {
        return String.Format("{0}+{1}*i", Re, Im);
    }
}

public static class ComplexMath
{
    public static double Abs(ComplexNumber a)
    {
        return Math.Sqrt(Norm(a));
    }

    public static double Norm(ComplexNumber a)
    {
        return a.Re * a.Re + a.Im * a.Im;
    }

    public static double Arg(ComplexNumber a)
    {
        return Math.Atan2(a.Im, a.Re);
    }

    public static ComplexNumber Inverse(ComplexNumber a)
    {
        double norm = Norm(a);
        return new ComplexNumber(a.Re / norm, -a.Im / norm);
    }

    public static ComplexNumber Conjugate(ComplexNumber a)
    {
        return new ComplexNumber(a.Re, -a.Im);

    }

    public static ComplexNumber Exp(ComplexNumber a)
    {
        double e = Math.Exp(a.Re);
        return new ComplexNumber(e * Math.Cos(a.Im), e * Math.Sin(a.Im));
    }

    public static ComplexNumber Log(ComplexNumber a)
    {

        return new ComplexNumber(0.5 * Math.Log(Norm(a)), Arg(a));
    }

    public static ComplexNumber Power(ComplexNumber a, ComplexNumber power)
    {
        return Exp(power * Log(a));
    }

    public static ComplexNumber Power(ComplexNumber a, int power)
    {
        bool inverse = false;
        if (power < 0)
        {
            inverse = true; power = -power;
        }

        ComplexNumber result = 1.0;
        ComplexNumber multiplier = a;
        while (power > 0)
        {
            if ((power & 1) != 0) result *= multiplier;
            multiplier *= multiplier;
            power >>= 1;
        }

        if (inverse)
            return Inverse(result);
        else
            return result;
    }

    public static ComplexNumber Sqrt(ComplexNumber a)
    {
        return Exp(0.5 * Log(a));
    }

    public static ComplexNumber Sin(ComplexNumber a)
    {
        return Sinh(ComplexNumber.i * a) / ComplexNumber.i;
    }

    public static ComplexNumber Cos(ComplexNumber a)
    {
        return Cosh(ComplexNumber.i * a);
    }

    public static ComplexNumber Sinh(ComplexNumber a)
    {
        return 0.5 * (Exp(a) - Exp(-a));
    }

    public static ComplexNumber Cosh(ComplexNumber a)
    {
        return 0.5 * (Exp(a) + Exp(-a));
    }

}

class Program
{
    static void Main(string[] args)
    {
        // usage
        ComplexNumber i = 2;
        ComplexNumber j = new ComplexNumber(1, -2);
        Console.WriteLine(i * j);
        Console.WriteLine(ComplexMath.Power(j, 2));
        Console.WriteLine((double)ComplexMath.Sin(i) + " vs " + Math.Sin(2));
        Console.WriteLine(ComplexMath.Power(j, 0) == 1.0);
    }
}
