using System;

class Program
{
    static int Call(Func<int, int, int> f, int a, int b)
    {
        return f(a, b);
    }

    static void Main()
    {
        int a = 6;
        int b = 2;

                                                                 // No lengthy delegate keyword.
        Console.WriteLine("f=Add, f({0}, {1}) = {2}", a, b, Call((int x, int y) => { return x + y; }, a, b));

                                                                 // Parameter types can be inferred.
        Console.WriteLine("f=Mul, f({0}, {1}) = {2}", a, b, Call((x, y) => { return x * y; }, a, b));

                                                                 // Expression lambdas are even shorter (and are most idiomatic).
        Console.WriteLine("f=Div, f({0}, {1}) = {2}", a, b, Call((x, y) => x / y, a, b));
    }
}
