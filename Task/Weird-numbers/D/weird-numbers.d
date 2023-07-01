import std.algorithm;
import std.array;
import std.stdio;

int[] divisors(int n) {
    int[] divs = [1];
    int[] divs2;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            int j = n / i;
            divs ~= i;
            if (i != j) {
                divs2 ~= j;
            }
        }
    }
    divs2 ~= divs.reverse;
    return divs2;
}

bool abundant(int n, int[] divs) {
    return divs.sum() > n;
}

bool semiperfect(int n, int[] divs) {
    // This algorithm is O(2^N) for N == divs.length when number is not semiperfect.
    // Comparing with (divs.sum < n) instead (divs.length==0) removes unnecessary
    // recursive binary tree branches.
    auto s = divs.sum;
    if(s == n)
      return true;
    else if ( s<n )
      return false;
    else {
        auto h = divs[0];
        auto t = divs[1..$];
        if (n < h) {
            return semiperfect(n, t);
        } else {
            return n == h
                // Supossin h is part of the sum
                || semiperfect(n - h, t)
                // Supossin h is not part of the sum
                || semiperfect(n, t);
        }
    }
}

bool[] sieve(int limit) {
    // false denotes abundant and not semi-perfect.
    // Only interested in even numbers >= 2
    auto w = uninitializedArray!(bool[])(limit);
    w[] = false;
    for (int i = 2; i < limit; i += 2) {
        if (w[i]) continue;
        auto divs = divisors(i);
        if (!abundant(i, divs)) {
            w[i] = true;
        } else if (semiperfect(i, divs)) {
            for (int j = i; j < limit; j += i) {
                w[j] = true;
            }
        }
    }
    return w;
}

void main() {
    auto w = sieve(17_000);
    int count = 0;
    int max = 25;
    writeln("The first 25 weird numbers:");
    for (int n = 2; count < max; n += 2) {
        if (!w[n]) {
            write(n, ' ');
            count++;
        }
    }
    writeln;
}
