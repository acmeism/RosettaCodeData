public class Permutations<T>
{
    public static System.Collections.Generic.IEnumerable<T[]> AllFor(T[] array)
    {
        if (array == null || array.Length == 0)
        {
            yield return new T[0];
        }
        else
        {
            for (int pick = 0; pick < array.Length; ++pick)
            {
                T item = array[pick];
                int i = -1;
                T[] rest = System.Array.FindAll<T>(
                    array, delegate(T p) { return ++i != pick; }
                );
                foreach (T[] restPermuted in AllFor(rest))
                {
                    i = -1;
                    yield return System.Array.ConvertAll<T, T>(
                        array,
                        delegate(T p) {
                            return ++i == 0 ? item : restPermuted[i - 1];
                        }
                    );
                }
            }
        }
    }
}
