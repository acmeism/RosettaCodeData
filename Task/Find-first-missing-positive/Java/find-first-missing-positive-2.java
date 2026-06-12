public static void main(String[] args) {
    List<int[]> tests = List.of(
            new int[]{1, 2, 0},
            new int[]{3, 4, -1, 1},
            new int[]{7, 8, 9, 11, 12},
            new int[]{1, 2, 3, 4, 5},
            new int[]{-6, -5, -2, -1},
            new int[]{5, -5},
            new int[]{-2},
            new int[]{1},
            new int[]{}
    );
    for (int[] test : tests)
        System.out.printf("%s => %s%n", Arrays.toString(test), firstMissingPositive(test));
}

private static int firstMissingPositive(int[] array) {
    final int min = 1;
    final int max = array.length;
    BitSet present = new BitSet(max);
    for (int num : array)
        if (min <= num && num <= max)
            present.set(num);
    return present.nextClearBit(min);
}
