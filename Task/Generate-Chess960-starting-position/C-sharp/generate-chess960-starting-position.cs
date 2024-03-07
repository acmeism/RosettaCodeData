using System;

class Program
{
    struct Symbols
    {
        public char K, Q, R, B, N;

        public Symbols(char k, char q, char r, char b, char n)
        {
            K = k; Q = q; R = r; B = b; N = n;
        }
    }

    private static Symbols A = new Symbols('K', 'Q', 'R', 'B', 'N');
    private static Symbols W = new Symbols('♔', '♕', '♖', '♗', '♘');
    private static Symbols B = new Symbols('♚', '♛', '♜', '♝', '♞');

    private static string[] krn = new string[]
    {
        "nnrkr", "nrnkr", "nrknr", "nrkrn",
        "rnnkr", "rnknr", "rnkrn",
        "rknnr", "rknrn",
        "rkrnn"
    };

    private static string Chess960(Symbols sym, int id)
    {
        char[] pos = new char[8];
        int q = id / 4, r = id % 4;
        pos[r * 2 + 1] = sym.B;
        r = q % 4; q /= 4;
        pos[r * 2] = sym.B;
        r = q % 6; q /= 6;
        int placementIndex = 0; // Adjusted variable name to prevent conflict
        for (int i = 0; ; i++)
        {
            if (pos[i] != '\0') continue;
            if (r == 0)
            {
                pos[i] = sym.Q;
                break;
            }
            r--;
        }
        while (pos[placementIndex] != '\0') placementIndex++; // Adjusted loop to prevent conflict
        foreach (char f in krn[q])
        {
            while (pos[placementIndex] != '\0') placementIndex++;
            switch (f)
            {
                case 'k':
                    pos[placementIndex] = sym.K;
                    break;
                case 'r':
                    pos[placementIndex] = sym.R;
                    break;
                case 'n':
                    pos[placementIndex] = sym.N;
                    break;
            }
        }
        return new string(pos);
    }

    static void Main(string[] args)
    {
        Console.WriteLine(" ID  Start position");
        foreach (int id in new int[] { 0, 518, 959 })
        {
            Console.WriteLine($"{id,3}  {Chess960(A, id)}");
        }
        Console.WriteLine("\nRandom");
        Random rand = new Random();
        for (int i = 0; i < 5; i++)
        {
            Console.WriteLine(Chess960(W, rand.Next(960)));
        }
    }
}
