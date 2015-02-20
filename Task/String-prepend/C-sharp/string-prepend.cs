using System;

namespace PrependString
{
    class Program
    {
        static void Main(string[] args)
        {
            string str = "World";
            str = "Hello " + str;
            Console.WriteLine(str);
            Console.ReadKey();
        }
    }
}
