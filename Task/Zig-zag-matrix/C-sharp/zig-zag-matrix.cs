public static int[,] ZigZag(int n)
{
    int[,] result = new int[n, n];
    int i = 0, j = 0;
    int d = -1; // -1 for top-right move, +1 for bottom-left move
    int start = 0, end = n * n - 1;
    do
    {
        result[i, j] = start++;
        result[n - i - 1, n - j - 1] = end--;

        i += d; j -= d;
        if (i < 0)
        {
            i++; d = -d; // top reached, reverse
        }
        else if (j < 0)
        {
            j++; d = -d; // left reached, reverse
        }
    } while (start < end);
    if (start == end)
        result[i, j] = start;
    return result;
}
