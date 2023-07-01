using System;

namespace RadixSort
{
    class Program
    {
        static void Sort(int[] old)
        {
            int i, j;
            int[] tmp = new int[old.Length];
            for (int shift = 31; shift > -1; --shift)
            {
                j = 0;
                for (i = 0; i < old.Length; ++i)
                {
                    bool move = (old[i] << shift) >= 0;
                    if (shift == 0 ? !move : move)  // shift the 0's to old's head
                        old[i-j] = old[i];
                    else                            // move the 1's to tmp
                        tmp[j++] = old[i];
                }
                Array.Copy(tmp, 0, old, old.Length-j, j);
            }
        }
        static void Main(string[] args)
        {
            int[] old = new int[] { 2, 5, 1, -3, 4 };
            Console.WriteLine(string.Join(", ", old));
            Sort(old);
            Console.WriteLine(string.Join(", ", old));
            Console.Read();
        }
    }
}
