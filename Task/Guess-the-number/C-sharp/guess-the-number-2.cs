using System; using System.Text; //daMilliard.cs
namespace DANILIN

{ class Program
    { static void Main(string[] args)
    { Random rand = new Random();int t=0;
int h2=100000000; int h1=0; int f=0;
int comp = rand.Next(h2);
int human = rand.Next(h2);

while (f<1)
{ Console.WriteLine();Console.Write(t);
Console.Write(" ");Console.Write(comp);
Console.Write(" ");Console.Write(human);

if(comp < human)
{ Console.Write(" MORE");
int a=comp; comp=(comp+h2)/2; h1=a; }

else if(comp > human)
{ Console.Write(" less");
int a=comp; comp=(h1+comp)/2; h2=a;}

else {Console.Write(" win by ");
Console.Write(t); Console.Write(" steps");f=1;}
t++; }}}}
