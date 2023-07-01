#define USE_BIGRATIONAL
#define BANDED_ROWS
#define INCREASED_LIMITS

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Numerics;
using Numerics;

using static Common;
using static Task1;
using static Task2;
using static Task3;

#if !USE_BIGRATIONAL
// Mock structure to make test code work.
struct BigRational
{
    public override string ToString() => "NOT USING BIGRATIONAL";
    public static explicit operator decimal(BigRational value) => -1;
}
#endif

static class Common
{
    public const string FMT_STR = "{0,4}   {1,-15:G9}   {2,-24:G17}   {3,-32}   {4,-32}";
    public static string Headings { get; } =
        string.Format(
            CultureInfo.InvariantCulture,
            FMT_STR,
            new[] { "N", "Single", "Double", "Decimal", "BigRational (rounded as Decimal)" });

    [Conditional("BANDED_ROWS")]
    static void SetConsoleFormat(int n)
    {
        if (n % 2 == 0)
        {
            Console.BackgroundColor = ConsoleColor.Black;
            Console.ForegroundColor = ConsoleColor.White;
        }
        else
        {
            Console.BackgroundColor = ConsoleColor.White;
            Console.ForegroundColor = ConsoleColor.Black;
        }
    }

    public static string FormatOutput(int n, (float sn, double db, decimal dm, BigRational br) x)
    {
        SetConsoleFormat(n);
        return string.Format(CultureInfo.CurrentCulture, FMT_STR, n, x.sn, x.db, x.dm, (decimal)x.br);
    }

    static void Main()
    {
        WrongConvergence();

        Console.WriteLine();
        ChaoticBankSociety();

        Console.WriteLine();
        SiegfriedRump();

        SetConsoleFormat(0);
    }
}
