using System;

delegate T Func<T>();

class ManOrBoy
{
    static void Main()
    {
        Console.WriteLine(A(10, C(1), C(-1), C(-1), C(1), C(0)));
    }

    static Func<int> C(int i)
    {
        return delegate { return i; };
    }

    static int A(int k, Func<int> x1, Func<int> x2, Func<int> x3, Func<int> x4, Func<int> x5)
    {
        Func<int> b = null;
        b = delegate { k--; return A(k, b, x1, x2, x3, x4); };
        return k <= 0 ? x4() + x5() : b();
    }
}
