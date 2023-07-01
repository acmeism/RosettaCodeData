using static System.Math;
using System.Linq;
using System;

public static class RangeConsolidation
{
    public static void Main() {
        foreach (var list in new [] {
            new[] { (1.1, 2.2) }.ToList(),
            new[] { (6.1, 7.2), (7.2, 8.3) }.ToList(),
            new[] { (4d, 3d), (2, 1) }.ToList(),
            new[] { (4d, 3d), (2, 1), (-1, 2), (3.9, 10) }.ToList(),
            new[] { (1d, 3d), (-6, -1), (-4, -5), (8, 2), (-6, -6) }.ToList()
        })
        {
            for (int z = list.Count-1; z >= 1; z--) {
                for (int y = z - 1; y >= 0; y--) {
                    if (Overlap(list[z], list[y])) {
                        list[y] = Consolidate(list[z], list[y]);
                        list.RemoveAt(z);
                        break;
                    }
                }
            }
            Console.WriteLine(string.Join(", ", list.Select(Normalize).OrderBy(range => range.s)));
        }
    }

    private static bool Overlap((double s, double e) left, (double s, double e) right) =>
        Max(left.s, left.e) > Max(right.s, right.e)
        ? Max(right.s, right.e) >= Min(left.s, left.e)
        : Max(left.s, left.e) >= Min(right.s, right.e);

    private static (double s, double e) Consolidate((double s, double e) left, (double s, double e) right) =>
        (Min(Min(left.s, left.e), Min(right.s, right.e)), Max(Max(left.s, left.e), Max(right.s, right.e)));

    private static (double s, double e) Normalize((double s, double e) range) =>
        (Min(range.s, range.e), Max(range.s, range.e));
}
