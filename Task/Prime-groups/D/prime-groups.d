import std.stdio, std.algorithm, std.range, std.math;

bool isPrime(int n) { return n >= 2 && iota(2, n).all!(i => n % i != 0); }

bool allDiffsPrime(char[] chars) {
    foreach (i, a; chars)
        foreach (j, b; chars[i + 1 .. $])
            if (!isPrime(abs(a - b)))
                return false;
    return true;
}

struct Subsets(T) {
    T[] arr;
    int n, k;
    int[] a;
    bool done;

    this(T[] arr, int k) {
        this.arr = arr;
        this.k = k;
        n = cast(int)arr.length;
        a = iota(k).array;
        done = (k <= 0 || k > n);
    }

    @property bool empty() { return done; }

    @property T[] front() { return a.map!(i => arr[i]).array; }

    void popFront() {
        int i = k - 1;
        while (i >= 0 && a[i] == n - k + i) i--;
        if (i < 0) { done = true; return; }
        a[i]++;
        foreach (j; i + 1 .. k) a[j] = a[j-1] + 1;
    }
}

string firstPrimeGroup(string s, int k) {
    foreach(subset; Subsets!char(s.dup, k))
        if (allDiffsPrime(subset))
            return subset.dup;
    return "Not found.";
}

void main() {
    auto testCases = ["riOtjuoq", "wjtiOxtj", "akwercjoeiJ", "Weej", "Aek", "jjgja"];

    foreach (testCase; testCases)
        writeln(firstPrimeGroup(testCase, 3));

    writeln();

    foreach (testCase; testCases)
        writeln(firstPrimeGroup(testCase, 2));
}
