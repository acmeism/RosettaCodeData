import std.stdio;

void main() {
    const arr = [0, 2, 11, 19, 90];
    const sum = 21;

    writeln(arr.twoSum(21));
}

/**
 * Searches arr for two indexes whose value adds to sum, and returns those indexes.
 * Returns an empty array if no such indexes exist.
 * The values of arr are assumed to be sorted.
 */
int[] twoSum(const int[] arr, const int sum) in {
    import std.algorithm.sorting : isSorted;
    assert(arr.isSorted);
} out(result) {
    assert(result.length == 0 || arr[result[0]] + arr[result[1]] == sum);
} do {
    int i = 0;
    int j = cast(int) arr.length - 1;

    while (i <= j) {
        auto temp = arr[i] + arr[j];
        if (temp == sum) {
            return [i, j];
        }

        if (temp < sum) {
            i++;
        } else {
            j--;
        }
    }

    return [];
}
