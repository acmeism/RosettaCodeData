using System;

class PCG32
{
    private const ulong N = 6364136223846793005;
    private ulong state = 0x853c49e6748fea9b;
    private ulong inc = 0xda3e39cb94b95bdb;

    public uint NextInt()
    {
        ulong old = state;
        state = old * N + inc;
        uint shifted = (uint)(((old >> 18) ^ old) >> 27);
        uint rot = (uint)(old >> 59);
        return (shifted >> (int)rot) | (shifted << (int)((~rot + 1) & 31));
    }

    public double NextFloat()
    {
        return ((double)NextInt()) / (1UL << 32);
    }

    public void Seed(ulong seedState, ulong seedSequence)
    {
        state = 0;
        inc = (seedSequence << 1) | 1;
        NextInt();
        state += seedState;
        NextInt();
    }
}

class Program
{
    static void Main(string[] args)
    {
        var r = new PCG32();

        r.Seed(42, 54);
        Console.WriteLine(r.NextInt());
        Console.WriteLine(r.NextInt());
        Console.WriteLine(r.NextInt());
        Console.WriteLine(r.NextInt());
        Console.WriteLine(r.NextInt());
        Console.WriteLine();

        int[] counts = new int[5];
        r.Seed(987654321, 1);
        for (int i = 0; i < 100000; i++)
        {
            int j = (int)Math.Floor(r.NextFloat() * 5.0);
            counts[j]++;
        }

        Console.WriteLine("The counts for 100,000 repetitions are:");
        for (int i = 0; i < counts.Length; i++)
        {
            Console.WriteLine($"  {i} : {counts[i]}");
        }
    }
}
