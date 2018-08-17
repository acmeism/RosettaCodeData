public static class LIS
{
    public static T[] Find<T>(IList<T> values, IComparer<T> comparer = null) {
        if (values == null) throw new ArgumentNullException();
        if (comparer == null) comparer = Comparer<T>.Default;
        var pileTops = new List<T>();
        var pileAssignments = new int[values.Count];
        for (int i = 0; i < values.Count; i++) {
            T element = values[i];
            int pile = pileTops.BinarySearch(element, comparer);
            if (pile < 0) pile = ~pile;
            if (pile == pileTops.Count) pileTops.Add(element);
            else pileTops[pile] = element;
            pileAssignments[i] = pile;
        }
        T[] result = new T[pileTops.Count];
        for (int i = pileAssignments.Length - 1, p = pileTops.Count - 1; p >= 0; i--) {
            if (pileAssignments[i] == p) result[p--] = values[i];
        }
        return result;
    }
}
