public static class Extension
{
    public static IEnumerable<IEnumerable<T>> Permutations<T>(this IEnumerable<T> values) where T : IComparable<T>
    {
        if (values.Count() == 1)
            return new[] { values };
        return values.SelectMany(v => Permutations(values.Where(x => x.CompareTo(v) != 0)), (v, p) => p.Prepend(v));
    }
}
