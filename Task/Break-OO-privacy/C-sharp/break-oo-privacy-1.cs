using System;
using System.Reflection;

public class MyClass
{
    private int answer = 42;
}

public class Program
{
    public static void Main()
    {
        var myInstance = new MyClass();
        var fieldInfo = typeof(MyClass).GetField("answer", BindingFlags.NonPublic | BindingFlags.Instance);
        var answer = fieldInfo.GetValue(myInstance);
        Console.WriteLine(answer);
    }
}
