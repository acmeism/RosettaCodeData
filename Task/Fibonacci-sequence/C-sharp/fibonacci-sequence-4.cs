using System; using System.Text; // FIBRUS.cs Russia
namespace Fibrus { class Program { static void Main()
{ long fi1=1; long fi2=1; long fi3=1; int da; int i; int d;
for (da=1; da<=78; da++) // rextester.com/MNGUV70257
    { d = 20-Convert.ToInt32((Convert.ToString(fi3)).Length);
    for (i=1; i<d; i++) Console.Write(".");
Console.Write(fi3); Console.Write(" "); Console.WriteLine(da);
    fi3 = fi2 + fi1;
    fi1 = fi2;
    fi2 = fi3;
}}}}
