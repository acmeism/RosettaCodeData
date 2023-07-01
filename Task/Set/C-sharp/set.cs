using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

class Program
{
    static void PrintCollection(IEnumerable<int> x)
    {
        Console.WriteLine(string.Join(" ", x));
    }
    static void Main(string[] args)
    {
        Console.OutputEncoding = Encoding.UTF8;
        Console.WriteLine("Set creation");
        var A = new HashSet<int> { 4, 12, 14, 17, 18, 19, 20 };
        var B = new HashSet<int> { 2, 5, 8, 11, 12, 13, 17, 18, 20 };

        PrintCollection(A);
        PrintCollection(B);

        Console.WriteLine("Test m ∈ S -- \"m is an element in set S\"");
        Console.WriteLine("14 is an element in set A: {0}", A.Contains(14));
        Console.WriteLine("15 is an element in set A: {0}", A.Contains(15));

        Console.WriteLine("A ∪ B -- union; a set of all elements either in set A or in set B.");
        var aUb = A.Union(B);
        PrintCollection(aUb);

        Console.WriteLine("A ∖ B -- difference; a set of all elements in set A, except those in set B.");
        var aDb = A.Except(B);
        PrintCollection(aDb);

        Console.WriteLine("A ⊆ B -- subset; true if every element in set A is also in set B.");
        Console.WriteLine(A.IsSubsetOf(B));
        var C = new HashSet<int> { 14, 17, 18 };
        Console.WriteLine(C.IsSubsetOf(A));

        Console.WriteLine("A = B -- equality; true if every element of set A is in set B and vice versa.");
        Console.WriteLine(A.SetEquals(B));
        var D = new HashSet<int> { 4, 12, 14, 17, 18, 19, 20 };
        Console.WriteLine(A.SetEquals(D));

        Console.WriteLine("If A ⊆ B, but A ≠ B, then A is called a true or proper subset of B, written A ⊂ B or A ⊊ B");
        Console.WriteLine(A.IsProperSubsetOf(B));
        Console.WriteLine(C.IsProperSubsetOf(A));

        Console.WriteLine("Modify a mutable set.  (Add 10 to A; remove 12 from B).");
        A.Add(10);
        B.Remove(12);
        PrintCollection(A);
        PrintCollection(B);

        Console.ReadKey();
    }
}
