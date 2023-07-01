using System;

class Example
{
    public int foo(int x)
    {
        return 42 + x;
    }
}

class Program
{
    static void Main(string[] args)
    {
        var example = new Example();
        var method = "foo";

        var result = (int)example.GetType().GetMethod(method).Invoke(example, new object[]{ 5 });
        Console.WriteLine("{0}(5) = {1}", method, result);
    }
}
