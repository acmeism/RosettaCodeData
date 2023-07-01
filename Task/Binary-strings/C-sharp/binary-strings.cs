using System;

class Program
{
    static void Main()
    {
        //string creation
        var x = "hello world";

        //# mark string for garbage collection
        x = null;

        //# string assignment with a null byte
        x = "ab\0";
        Console.WriteLine(x);
        Console.WriteLine(x.Length); // 3

        //# string comparison
        if (x == "hello")
            Console.WriteLine("equal");
        else
            Console.WriteLine("not equal");

        if (x.CompareTo("bc") == -1)
            Console.WriteLine("x is lexicographically less than 'bc'");

        //# string cloning
        var c = new char[3];
        x.CopyTo(0, c, 0, 3);
        object objecty = new string(c);
        var y = new string(c);

        Console.WriteLine(x == y);      //same as string.equals
        Console.WriteLine(x.Equals(y)); //it overrides object.Equals

        Console.WriteLine(x == objecty); //uses object.Equals, return false

        //# check if empty
        var empty = "";
        string nullString = null;
        var whitespace = "   ";
        if (nullString == null && empty == string.Empty &&
            string.IsNullOrEmpty(nullString) && string.IsNullOrEmpty(empty) &&
            string.IsNullOrWhiteSpace(nullString) && string.IsNullOrWhiteSpace(empty) &&
            string.IsNullOrWhiteSpace(whitespace))
            Console.WriteLine("Strings are null, empty or whitespace");

        //# append a byte
        x = "helloworld";
        x += (char)83;
        Console.WriteLine(x);

        //# substring
        var slice = x.Substring(5, 5);
        Console.WriteLine(slice);

        //# replace bytes
        var greeting = x.Replace("worldS", "");
        Console.WriteLine(greeting);

        //# join strings
        var join = greeting + " " + slice;
        Console.WriteLine(join);
    }
}
