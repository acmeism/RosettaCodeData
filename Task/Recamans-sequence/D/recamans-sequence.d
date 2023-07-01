import std.stdio;

void main() {
    int[] a;
    bool[int] used;
    bool[int] used1000;
    bool foundDup;

    a ~= 0;
    used[0] = true;
    used1000[0] = true;

    int n = 1;
    while (n <= 15 || !foundDup || used1000.length < 1001) {
        int next = a[n - 1] - n;
        if (next < 1 || (next in used) !is null) {
            next += 2 * n;
        }
        bool alreadyUsed = (next in used) !is null;
        a ~= next;
        if (!alreadyUsed) {
            used[next] = true;
            if (0 <= next && next <= 1000) {
                used1000[next] = true;
            }
        }
        if (n == 14) {
            writeln("The first 15 terms of the Recaman sequence are: ", a);
        }
        if (!foundDup && alreadyUsed) {
            writefln("The first duplicated term is a[%d] = %d", n, next);
            foundDup = true;
        }
        if (used1000.length == 1001) {
            writefln("Terms up to a[%d] are needed to generate 0 to 1000", n);
        }
        n++;
    }
}
