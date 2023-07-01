using System;

static string Ordinalize(int i)
{
    return i + (
        i % 100 is >= 11 and <= 13 ? "th" :
        i % 10 == 1 ? "st" :
        i % 10 == 2 ? "nd" :
        i % 10 == 3 ? "rd" :
        "th");
}

static void PrintRange(int begin, int end)
{
    for(var i = begin; i <= end; i++)
        Console.Write(Ordinalize(i) + (i == end ? "" : " "));
    Console.WriteLine();
}

PrintRange(0, 25);
PrintRange(250, 265);
PrintRange(1000, 1025);
