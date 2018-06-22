public class Program
{
    public static void Main()
    {
        const int count = 5;
        const int Baker = 0, Cooper = 1, Fletcher = 2, Miller = 3, Smith = 4;
        string[] names = { nameof(Baker), nameof(Cooper), nameof(Fletcher), nameof(Miller), nameof(Smith) };

        Func<int[], bool>[] constraints = {
            floorOf => floorOf[Baker] != count-1,
            floorOf => floorOf[Cooper] != 0,
            floorOf => floorOf[Fletcher] != count-1 && floorOf[Fletcher] != 0,
            floorOf => floorOf[Miller] > floorOf[Cooper],
            floorOf => Math.Abs(floorOf[Smith] - floorOf[Fletcher]) > 1,
            floorOf => Math.Abs(floorOf[Fletcher] - floorOf[Cooper]) > 1,
        };

        var solver = new DinesmanSolver();
        foreach (var tenants in solver.Solve(count, constraints)) {
            Console.WriteLine(string.Join(" ", tenants.Select(t => names[t])));
        }
    }
}

public class DinesmanSolver
{
    public IEnumerable<int[]> Solve(int count, params Func<int[], bool>[] constraints) {
        foreach (int[] floorOf in Permutations(count)) {
            if (constraints.All(c => c(floorOf))) {
                yield return Enumerable.Range(0, count).OrderBy(i => floorOf[i]).ToArray();
            }
        }
    }

    static IEnumerable<int[]> Permutations(int length) {
        if (length == 0) {
            yield return new int[0];
            yield break;
        }
        bool forwards = false;
        foreach (var permutation in Permutations(length - 1)) {
            for (int i = 0; i < length; i++) {
                yield return permutation.InsertAt(forwards ? i : length - i - 1, length - 1).ToArray();
            }
            forwards = !forwards;
        }
    }
}

static class Extensions
{
    public static IEnumerable<T> InsertAt<T>(this IEnumerable<T> source, int position, T newElement) {
        if (source == null) throw new ArgumentNullException(nameof(source));
        if (position < 0) throw new ArgumentOutOfRangeException(nameof(position));
        return InsertAtIterator(source, position, newElement);
    }

    private static IEnumerable<T> InsertAtIterator<T>(IEnumerable<T> source, int position, T newElement) {
        int index = 0;
        foreach (T element in source) {
            if (index == position) yield return newElement;
            yield return element;
            index++;
        }
        if (index < position) throw new ArgumentOutOfRangeException(nameof(position));
        if (index == position) yield return newElement;
    }
}
