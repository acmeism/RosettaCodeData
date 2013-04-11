using System;
delegate int Func2(int a, int b);
class Program
{
    static int Call(Func2 f, int a, int b)
    {
        return f(a, b);
    }

    static void Main()
    {
        int a = 6;
        int b = 2;

        Console.WriteLine("f=Add, f({0}, {1}) = {2}", a, b, Call(delegate(int x, int y) { return x + y; }, a, b));
        Console.WriteLine("f=Mul, f({0}, {1}) = {2}", a, b, Call(delegate(int x, int y) { return x * y; }, a, b));
        Console.WriteLine("f=Div, f({0}, {1}) = {2}", a, b, Call(delegate(int x, int y) { return x / y; }, a, b));
    }
}
