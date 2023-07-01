using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public static class LIS
{
    public static IEnumerable<T> FindRec<T>(IList<T> values, IComparer<T> comparer = null) =>
        values == null ? throw new ArgumentNullException() :
            FindRecImpl(values, Sequence<T>.Empty, 0, comparer ?? Comparer<T>.Default).Reverse();

    private static Sequence<T> FindRecImpl<T>(IList<T> values, Sequence<T> current, int index, IComparer<T> comparer) {
        if (index == values.Count) return current;
        if (current.Length > 0 && comparer.Compare(values[index], current.Value) <= 0)
            return FindRecImpl(values, current, index + 1, comparer);
        return Max(
            FindRecImpl(values, current, index + 1, comparer),
            FindRecImpl(values, current + values[index], index + 1, comparer)
        );
    }

    private static Sequence<T> Max<T>(Sequence<T> a, Sequence<T> b) => a.Length < b.Length ? b : a;

    class Sequence<T> : IEnumerable<T>
    {
        public static readonly Sequence<T> Empty = new Sequence<T>(default(T), null);

        public Sequence(T value, Sequence<T> tail)
        {
            Value = value;
            Tail = tail;
            Length = tail == null ? 0 : tail.Length + 1;
        }

        public T Value { get; }
        public Sequence<T> Tail { get; }
        public int Length { get; }

        public static Sequence<T> operator +(Sequence<T> s, T value) => new Sequence<T>(value, s);

        public IEnumerator<T> GetEnumerator()
        {
            for (var s = this; s.Length > 0; s = s.Tail) yield return s.Value;
        }

        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }
}
