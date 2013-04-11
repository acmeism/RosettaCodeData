using System;
delegate int Func2(int a, int b);
class Program
{
    static int Add(int a, int b)
    {
        return a + b;
    }

    static int Mul(int a, int b)
    {
        return a * b;
    }

    static int Div(int a, int b)
    {
        return a / b;
    }

    static int Call(Func2 f, int a, int b)
    {
        return f(a, b);
    }

    static void Main()
    {
        int a = 6;
        int b = 2;

        Func2 add = new Func2(Add);
        Func2 mul = new Func2(Mul);
        Func2 div = new Func2(Div);

        Console.WriteLine("f=Add, f({0}, {1}) = {2}", a, b, Call(add, a, b));
        Console.WriteLine("f=Mul, f({0}, {1}) = {2}", a, b, Call(mul, a, b));
        Console.WriteLine("f=Div, f({0}, {1}) = {2}", a, b, Call(div, a, b));
    }
}
