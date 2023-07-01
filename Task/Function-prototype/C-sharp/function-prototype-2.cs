using System;
public delegate int IntFunction(int a, int b);

public class Program
{
    public static int Add(int x, int y) {
        return x + y;
    }

    public static int Multiply(int x, int y) {
        return x * y;
    }

    public static void Main() {
        IntFunction func = Add;
        Console.WriteLine(func(2, 3)); //prints 5
        func = Multiply;
        Console.WriteLine(func(2, 3)); //prints 6
        func += Add;
        Console.WriteLine(func(2, 3)); //prints 5. Both functions are called, but only the last result is kept.
    }
}
