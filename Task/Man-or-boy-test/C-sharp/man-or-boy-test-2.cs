using System;

class ManOrBoy
{
    static void Main()
    {
        Console.WriteLine(A(10, () => 1, () => -1, () => -1, () => 1, () => 0));
    }

    static int A(int k, Func<int> x1, Func<int> x2, Func<int> x3, Func<int> x4, Func<int> x5)
    {
        Func<int> b = null;
        b = () => { k--; return A(k, b, x1, x2, x3, x4); };
        return k <= 0 ? x4() + x5() : b();
    }
}
