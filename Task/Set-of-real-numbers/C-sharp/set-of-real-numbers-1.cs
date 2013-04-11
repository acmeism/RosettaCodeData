using System;

namespace RosettaCode.SetOfRealNumbers
{
    public class Set<TValue>
    {
        public Set(Predicate<TValue> contains)
        {
            Contains = contains;
        }

        public Predicate<TValue> Contains
        {
            get;
            private set;
        }

        public Set<TValue> Union(Set<TValue> set)
        {
            return new Set<TValue>(value => Contains(value) || set.Contains(value));
        }

        public Set<TValue> Intersection(Set<TValue> set)
        {
            return new Set<TValue>(value => Contains(value) && set.Contains(value));
        }

        public Set<TValue> Difference(Set<TValue> set)
        {
            return new Set<TValue>(value => Contains(value) && !set.Contains(value));
        }
    }
}
