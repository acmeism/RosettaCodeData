public static class ShellSorter
{
    public static void Sort<T>(IList<T> list) where T : IComparable
    {
        int n = list.Count;
        int h = 1;

        while (h < (n >> 1))
        {
            h = (h << 1) + 1;
        }

        while (h >= 1)
        {
            for (int i = h; i < n; i++)
            {
                int k = i - h;
                for (int j = i; j >= h && list[j].CompareTo(list[k]) < 0; k -= h)
                {
                    T temp = list[j];
                    list[j] = list[k];
                    list[k] = temp;
                    j = k;
                }
            }
            h >>= 1;
        }
    }
}
