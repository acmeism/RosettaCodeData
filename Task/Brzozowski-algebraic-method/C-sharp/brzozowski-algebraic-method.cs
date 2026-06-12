using System;

abstract class RE
{
    public static readonly RE empty = new Empty();
    public static readonly RE epsilon = new Epsilon();

    public abstract override string ToString();
    public abstract override bool Equals(object obj);
    public abstract override int GetHashCode();
}

class Empty : RE
{
    public override string ToString() => "0";

    public override bool Equals(object obj) => obj is Empty;

    public override int GetHashCode() => typeof(Empty).GetHashCode();
}

class Epsilon : RE
{
    public override string ToString() => "1";

    public override bool Equals(object obj) => obj is Epsilon;

    public override int GetHashCode() => typeof(Epsilon).GetHashCode();
}

class Car : RE
{
    public string c;

    public Car(string c) => this.c = c;

    public override string ToString() => c;

    public override bool Equals(object obj) => obj is Car other && c == other.c;

    public override int GetHashCode() => c.GetHashCode();
}

class Union : RE
{
    public RE e, f;

    public Union(RE e, RE f)
    {
        this.e = e;
        this.f = f;
    }

    public override string ToString() => $"{e}+{f}";

    public override bool Equals(object obj) => obj is Union other && e.Equals(other.e) && f.Equals(other.f);

    public override int GetHashCode() => e.GetHashCode() * 17 + f.GetHashCode();
}

class Concat : RE
{
    public RE e, f;

    public Concat(RE e, RE f)
    {
        this.e = e;
        this.f = f;
    }

    public override string ToString() => $"({e})({f})";

    public override bool Equals(object obj) => obj is Concat other && e.Equals(other.e) && f.Equals(other.f);

    public override int GetHashCode() => e.GetHashCode() * 17 + f.GetHashCode();
}

class Star : RE
{
    public RE e;

    public Star(RE e) => this.e = e;

    public override string ToString() => $"({e})*";

    public override bool Equals(object obj) => obj is Star other && e.Equals(other.e);

    public override int GetHashCode() => e.GetHashCode() * 31;
}

class Program
{
    static RE SimpleRe(RE e)
    {
        RE Simple(RE expr)
        {
            if (expr is Union union)
            {
                RE e_e = Simple(union.e);
                RE e_f = Simple(union.f);
                if (e_e.Equals(e_f))
                    return e_e;
                else if (e_e is Union e_e_union)
                    return Simple(new Union(e_e_union.e, new Union(e_e_union.f, e_f)));
                else if (e_e.Equals(RE.empty))
                    return e_f;
                else if (e_f.Equals(RE.empty))
                    return e_e;
                else
                    return new Union(e_e, e_f);
            }
            else if (expr is Concat concat)
            {
                RE e_e = Simple(concat.e);
                RE e_f = Simple(concat.f);
                if (e_e.Equals(RE.epsilon))
                    return e_f;
                else if (e_f.Equals(RE.epsilon))
                    return e_e;
                else if (e_e.Equals(RE.empty) || e_f.Equals(RE.empty))
                    return RE.empty;
                else if (e_e is Concat e_e_concat)
                    return Simple(new Concat(e_e_concat.e, new Concat(e_e_concat.f, e_f)));
                else
                    return new Concat(e_e, e_f);
            }
            else if (expr is Star star)
            {
                RE e_e = Simple(star.e);
                if (e_e is Empty || e_e is Epsilon)
                    return RE.epsilon;
                else
                    return new Star(e_e);
            }
            else
                return expr;
        }

        RE prev_e = null;
        while (!e.Equals(prev_e))
        {
            prev_e = e;
            e = Simple(e);
        }
        return e;
    }

    static RE Brzozowski(RE[][] a, RE[] b)
    {
        int m = a.Length;
        for (int n = m - 1; n >= 0; n--)
        {
            RE a_nn = a[n][n];
            b[n] = new Concat(new Star(a_nn), b[n]);
            for (int j = 0; j < n; j++)
                a[n][j] = new Concat(new Star(a_nn), a[n][j]);
            for (int i = 0; i < n; i++)
            {
                b[i] = new Union(b[i], new Concat(a[i][n], b[n]));
                for (int j = 0; j < n; j++)
                    a[i][j] = new Union(a[i][j], new Concat(a[i][n], a[n][j]));
            }
            for (int i = 0; i < n; i++)
                a[i][n] = RE.empty;
        }
        return b[0];
    }

    static void Main(string[] args)
    {
        RE[][] a = new RE[][]
        {
            new RE[] { RE.empty, new Car("a"), new Car("b") },
            new RE[] { new Car("b"), RE.empty, new Car("a") },
            new RE[] { new Car("a"), new Car("b"), RE.empty },
        };

        RE[] b = new RE[] { RE.epsilon, RE.empty, RE.empty };

        RE re = Brzozowski(a, b);
        Console.WriteLine(re.ToString());
        Console.WriteLine();
        Console.WriteLine(SimpleRe(re).ToString());
    }
}
