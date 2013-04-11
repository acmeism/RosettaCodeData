private static int BiggestSubsum(int[] t) {
    int sum = 0;
    int maxsum = 0;

    for (int i : t) {
        sum += i;
        if (sum < 0)
            sum = 0;
        maxsum = sum > maxsum ? sum : maxsum;
    }
    return maxsum;
}
