public static class PermutationSorter
{
    public static void Sort<T>(List<T> list) where T : IComparable
    {
        PermutationSort(list, 0);
    }
    public static bool PermutationSort<T>(List<T> list, int i) where T : IComparable
    {
        int j;
        if (issorted(list, i))
        {
            return true;
        }
        for (j = i + 1; j < list.Count; j++)
        {
            T temp = list[i];
            list[i] = list[j];
            list[j] = temp;
            if (PermutationSort(list, i + 1))
            {
                return true;
            }
            temp = list[i];
            list[i] = list[j];
            list[j] = temp;
        }
        return false;
    }
    public static bool issorted<T>(List<T> list, int i) where T : IComparable
    {
	    for (int j = list.Count-1; j > 0; j--)
        {
	        if(list[j].CompareTo(list[j-1])<0)
            {
		        return false;
	        }
	    }
	    return true;
    }
}
