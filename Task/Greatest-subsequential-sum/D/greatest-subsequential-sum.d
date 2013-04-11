import std.stdio;

inout(T[]) maxSubseq(T)(inout T[] sequence) pure nothrow {
    int maxSum, thisSum, i, start, end = -1;

    foreach (j, x; sequence) {
        thisSum += x;
        if (thisSum < 0) {
            i = j + 1;
            thisSum = 0;
        } else if (thisSum > maxSum) {
            maxSum = thisSum;
            start = i;
            end   = j;
        }
    }

    if (start <= end && start >= 0 && end >= 0)
        return sequence[start .. end + 1];
    else
        return [];
}

void main() {
    const a1 = [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1];
    writeln("Maximal subsequence: ", maxSubseq(a1));

    const a2 = [-1, -2, -3, -5, -6, -2, -1, -4, -4, -2, -1];
    writeln("Maximal subsequence: ", maxSubseq(a2));
}
