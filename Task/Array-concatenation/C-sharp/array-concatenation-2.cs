using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        int[] a = { 1, 2, 3 };
        int[] b = { 4, 5, 6 };

        int[] c = a.Concat(b).ToArray();
    }
}
