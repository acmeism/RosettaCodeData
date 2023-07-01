class Program
{
// Variable names key:
//   i Iterator (of the tower block array).
// tba Tower block array.
// tea Tower elevation array.
// rht Right hand tower column number (position).
//  wu Water units (count).
// bof Blocks on floor (count).
// col Column number in elevation array (position).

    static void Main(string[] args)
    {
        int i = 1; int[][] tba = {new int[] { 1, 5, 3, 7, 2 },
        new int[] { 5, 3, 7, 2, 6, 4, 5, 9, 1, 2 },
        new int[] { 2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1 },
        new int[] { 5, 5, 5, 5 },  new int[] { 5, 6, 7, 8 },
        new int[] { 8, 7, 7, 6 },  new int[] { 6, 7, 10, 7, 6 }};
        foreach (int[] tea in tba)
        {
            int rht, wu = 0, bof; do
            {
                for (rht = tea.Length - 1; rht >= 0; rht--)
                    if (tea[rht] > 0) break;
                if (rht < 0) break;
                bof = 0; for (int col = 0; col <= rht; col++)
                {
                    if (tea[col] > 0) { tea[col] -= 1; bof += 1; }
                    else if (bof > 0) wu++;
                }
                if (bof < 2) break;
            } while (true);
            System.Console.WriteLine(string.Format("Block {0} {1} water units.",
                i++, wu == 0 ? "does not hold any" : "holds " + wu.ToString()));
        }
    }
}
