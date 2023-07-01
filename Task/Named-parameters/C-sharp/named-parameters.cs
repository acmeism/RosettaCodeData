using System;

namespace NamedParams
{
    class Program
    {
        static void AddWidget(string parent, float x = 0, float y = 0, string text = "Default")
        {
            Console.WriteLine("parent = {0}, x = {1}, y = {2}, text = {3}", parent, x, y, text);
        }

        static void Main(string[] args)
        {
            AddWidget("root", 320, 240, "First");
            AddWidget("root", text: "Origin");
            AddWidget("root", 500);
            AddWidget("root", text: "Footer", y: 400);
        }
    }
}
