// Always returns the same array which is the one passed to the function
public static IEnumerable<T[]> HeapsPermutations<T>(T[] array)
{
    var state = new int[array.Length];

    yield return array;

    for (var i = 0; i < array.Length;)
    {
        if (state[i] < i)
        {
            var left = i % 2 == 0 ? 0 : state[i];
            var temp = array[left];
            array[left] = array[i];
            array[i] = temp;
            yield return array;
            state[i]++;
            i = 1;
        }
        else
        {
            state[i] = 0;
            i++;
        }
    }
}

// Returns a different array for each permutation
public static IEnumerable<T[]> HeapsPermutationsWrapped<T>(IEnumerable<T> items)
{
    var array = items.ToArray();
    return HeapsPermutations(array).Select(mutating =>
        {
            var arr = new T[array.Length];
            Array.Copy(mutating, arr, array.Length);
            return arr;
        });
}
