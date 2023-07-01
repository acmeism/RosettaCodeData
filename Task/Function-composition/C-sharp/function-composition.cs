using System;
class Program
{
    static void Main(string[] args)
    {
        Func<int, int> outfunc = Composer<int, int, int>.Compose(functA, functB);
        Console.WriteLine(outfunc(5)); //Prints 100
    }
    static int functA(int i) { return i * 10; }
    static int functB(int i) { return i + 5; }
    class Composer<A, B, C>
    {
        public static Func<C, A> Compose(Func<B, A> a, Func<C, B> b)
        {
            return delegate(C i) { return a(b(i)); };
        }
    }
}
