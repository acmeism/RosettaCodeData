// Translated from C++ by Nigel Galloway

new FifteenSolver(8, 0xFE169B4C0A73D852).Solve();

class FifteenSolver
{
    readonly int[] RowIndex = [3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3];
    readonly int[] ColIndex = [3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2];
    int n = 0, maxCost = 0;
    readonly int[] Hole = new int[100];
    readonly char[] Move = new char[100];
    readonly int[] Cost = new int[100];
    readonly ulong[] State = new ulong[100];

    bool Scan()
    {
        if (Cost[n] < maxCost)
            return Explore();

        if (State[n] == 0x123456789ABCDEF0)
        {
            Console.WriteLine($"Solution found in {n} moves :");

            for (var g = 1; g <= n; ++g)
                Console.Write(Move[g]);

            Console.WriteLine();
            return true;
        }

        if (Cost[n] == maxCost)
            return Explore();

        return false;
    }

    bool Explore()
    {
        if (Move[n] != 'u' && Hole[n] / 4 < 3) { Down(); ++n; if (Scan()) return true; --n; }
        if (Move[n] != 'd' && Hole[n] / 4 > 0) { Up(); ++n; if (Scan()) return true; --n; }
        if (Move[n] != 'l' && Hole[n] % 4 < 3) { Right(); ++n; if (Scan()) return true; --n; }
        if (Move[n] != 'r' && Hole[n] % 4 > 0) { Left(); ++n; if (Scan()) return true; --n; }
        return false;
    }

    void Down()
    {
        var shift = (11 - Hole[n]) * 4;
        var a = State[n] & (0xFUL << shift);
        Hole[n + 1] = Hole[n] + 4;
        State[n + 1] = State[n] - a + (a << 16);
        Move[n + 1] = 'd';
        Cost[n + 1] = Cost[n] + (RowIndex[a >> shift] <= Hole[n] / 4 ? 0 : 1);
    }

    void Up()
    {
        var shift = (19 - Hole[n]) * 4;
        var a = State[n] & (0xFUL << shift);
        Hole[n + 1] = Hole[n] - 4;
        State[n + 1] = State[n] - a + (a >> 16);
        Move[n + 1] = 'u';
        Cost[n + 1] = Cost[n] + (RowIndex[a >> shift] >= Hole[n] / 4 ? 0 : 1);
    }

    void Right()
    {
        var shift = (14 - Hole[n]) * 4;
        var a = State[n] & (0xFUL << shift);
        Hole[n + 1] = Hole[n] + 1;
        State[n + 1] = State[n] - a + (a << 4);
        Move[n + 1] = 'r';
        Cost[n + 1] = Cost[n] + (ColIndex[a >> shift] <= Hole[n] % 4 ? 0 : 1);
    }

    void Left()
    {
        int shift = (16 - Hole[n]) * 4;
        ulong a = State[n] & (0xFUL << shift);
        Hole[n + 1] = Hole[n] - 1;
        State[n + 1] = State[n] - a + (a >> 4);
        Move[n + 1] = 'l';
        Cost[n + 1] = Cost[n] + (ColIndex[a >> shift] >= Hole[n] % 4 ? 0 : 1);
    }

    public FifteenSolver(int n, ulong g)
    {
        Hole[0] = n;
        State[0] = g;
    }

    public void Solve()
    {
        for (; !Scan(); ++maxCost)
            ;
    }
}
