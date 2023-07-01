import std.algorithm;
import std.stdio;

int[] getDivisors(int n) {
    auto divs = [1, n];
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            divs ~= i;

            int j = n / i;
            if (i != j) {
                divs ~= j;
            }
        }
    }
    return divs;
}

bool isPartSum(int[] divs, int sum) {
    if (sum == 0) {
        return true;
    }
    auto le = divs.length;
    if (le == 0) {
        return false;
    }
    auto last = divs[$ - 1];
    int[] newDivs;
    for (int i = 0; i < le - 1; i++) {
        newDivs ~= divs[i];
    }
    if (last > sum) {
        return isPartSum(newDivs, sum);
    } else {
        return isPartSum(newDivs, sum) || isPartSum(newDivs, sum - last);
    }
}

bool isZumkeller(int n) {
    auto divs = getDivisors(n);
    auto sum = divs.sum();
    // if sum is odd can't be split into two partitions with equal sums
    if (sum % 2 == 1) {
        return false;
    }
    // if n is odd use 'abundant odd number' optimization
    if (n % 2 == 1) {
        auto abundance = sum - 2 * n;
        return abundance > 0 && abundance % 2 == 0;
    }
    // if n and sum are both even check if there's a partition which totals sum / 2
    return isPartSum(divs, sum / 2);
}

void main() {
    writeln("The first 220 Zumkeller numbers are:");
    int i = 2;
    for (int count = 0; count < 220; i++) {
        if (isZumkeller(i)) {
            writef("%3d ", i);
            count++;
            if (count % 20 == 0) {
                writeln;
            }
        }
    }

    writeln("\nThe first 40 odd Zumkeller numbers are:");
    i = 3;
    for (int count = 0; count < 40; i += 2) {
        if (isZumkeller(i)) {
            writef("%5d ", i);
            count++;
            if (count % 10 == 0) {
                writeln;
            }
        }
    }

    writeln("\nThe first 40 odd Zumkeller numbers which don't end in 5 are:");
    i = 3;
    for (int count = 0; count < 40; i += 2) {
        if (i % 10 != 5 && isZumkeller(i)) {
            writef("%7d ", i);
            count++;
            if (count % 8 == 0) {
                writeln;
            }
        }
    }
}
