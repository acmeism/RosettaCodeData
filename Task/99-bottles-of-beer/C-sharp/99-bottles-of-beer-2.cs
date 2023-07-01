using System;
class Program
{
    static void Main()
    {
        Func<int, bool, string> f = (x, y) =>
            $"{(x == 0 ? "No more" : x.ToString())} bottle{(x == 1 ? "" : "s")} of beer{(y ? " on the wall" : "")}\r\n";
        for (int i = 99; i > 0; i--)
            Console.WriteLine($"{f(i, true)}{f(i, false)}Take one down, pass it around\r\n{f(i - 1, true)}");
    }
}
