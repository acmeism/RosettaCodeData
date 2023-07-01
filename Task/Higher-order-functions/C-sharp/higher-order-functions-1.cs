using System;

// A delegate declaration. Because delegates are types, they can exist directly in namespaces.
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
        // Invoking a delegate like a method is syntax sugar; this compiles down to f.Invoke(a, b);
        return f(a, b);
    }

    static void Main()
    {
        int a = 6;
        int b = 2;

        // Delegates must be created using the "constructor" syntax in C# 1.0; in C# 2.0 and above, only the name of the method is required (when a target type exists, such as in an assignment to a variable with a delegate type or usage in a function call with a parameter of a delegate type; initializers of implicitly typed variables must use the constructor syntax as a raw method has no delegate type). Overload resolution is performed using the parameter types of the target delegate type.
        Func2 add = new Func2(Add);
        Func2 mul = new Func2(Mul);
        Func2 div = new Func2(Div);

        Console.WriteLine("f=Add, f({0}, {1}) = {2}", a, b, Call(add, a, b));
        Console.WriteLine("f=Mul, f({0}, {1}) = {2}", a, b, Call(mul, a, b));
        Console.WriteLine("f=Div, f({0}, {1}) = {2}", a, b, Call(div, a, b));
    }
}
