//file1.cs
public partial class Program
{
    partial void Print();
}

//file2.cs
using System;

public partial class Program
{
    partial void Print() {
        Console.WriteLine("Hello world!");
    }

    static void Main() {
        Program p = new Program();
        p.Print(); //If the implementation above is not written, the compiler will remove this line.
    }
}
