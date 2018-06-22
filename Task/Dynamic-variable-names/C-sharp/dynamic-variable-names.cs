using System;
using System.Dynamic;
using System.Collections.Generic;

public class Program
{
    public static void Main()
    {
        string varname = Console.ReadLine();
        //Let's pretend the user has entered "foo"
        dynamic expando = new ExpandoObject();
        var map = expando as IDictionary<string, object>;
        map.Add(varname, "Hello world!");

        Console.WriteLine(expando.foo);
    }
}
