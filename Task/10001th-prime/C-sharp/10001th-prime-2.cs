using System; using System.Text; // PRIME_numb.cs russian DANILIN
namespace p10001 // 1 second  10001  104743
{ class Program // rextester.com/ZBEPGE34760
    { static void Main(string[] args)
        { int max=10001; int n=1; int p=1; int f; int j; long s;
            while (n <= max)
            { f=0; j=2; s=Convert.ToInt32(Math.Pow(p,0.5));
                while (f < 1)
                { if (j >= s)
                    { f=2; }
                  if (p % j == 0) { f=1; }
                  j++;
                }
                if (f != 1) { n++; } // Console.WriteLine("{0} {1}", n, p);
                p++;
            }
Console.Write("{0} {1}", n-1, p-1);
Console.ReadKey();
}}}
