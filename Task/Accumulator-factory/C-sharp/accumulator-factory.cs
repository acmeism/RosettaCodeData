using System;

class Program
{
    static Func<dynamic, dynamic> Foo(dynamic n)
    {
        return i => n += i;
    }

    static void Main(string[] args)
    {
        var x = Foo(1);
        x(5);
        Foo(3);
        Console.WriteLine(x(2.3));
    }
}
