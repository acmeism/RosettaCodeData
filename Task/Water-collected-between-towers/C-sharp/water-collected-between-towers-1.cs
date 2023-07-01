class Program
{
    static void Main(string[] args)
    {
        int[][] wta = {
            new int[] {1, 5, 3, 7, 2},   new int[] { 5, 3, 7, 2, 6, 4, 5, 9, 1, 2 },
            new int[] { 2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1 },
            new int[] { 5, 5, 5, 5 },    new int[] { 5, 6, 7, 8 },
            new int[] { 8, 7, 7, 6 },    new int[] { 6, 7, 10, 7, 6 }};
        string blk, lf = "\n", tb = "██", wr = "≈≈", mt = "  ";
        for (int i = 0; i < wta.Length; i++)
        {
            int bpf; blk = ""; do
            {
                string floor = ""; bpf = 0; for (int j = 0; j < wta[i].Length; j++)
                {
                    if (wta[i][j] > 0)
                    {    floor += tb; wta[i][j] -= 1; bpf += 1; }
                    else floor += (j > 0 && j < wta[i].Length - 1 ? wr : mt);
                }
                if (bpf > 0) blk = floor + lf + blk;
            } while (bpf > 0);
            while (blk.Contains(mt + wr)) blk = blk.Replace(mt + wr, mt + mt);
            while (blk.Contains(wr + mt)) blk = blk.Replace(wr + mt, mt + mt);
            if (args.Length > 0) System.Console.Write("\n{0}", blk);
            System.Console.WriteLine("Block {0} retains {1,2} water units.",
                i + 1, (blk.Length - blk.Replace(wr, "").Length) / 2);
        }
    }
}
