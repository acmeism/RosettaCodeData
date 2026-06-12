import std.stdio : writefln;
import std.math : pow;

bool ends_with_one(uint number) {
    uint sum = 0;
    while (true) {
        while (number > 0) {
            uint digit = number % 10;
            sum += digit * digit;
            number /= 10;
        }

        if (sum == 1) {
            return true;
        }
        if (sum == 89) {
            return false;
        }
        number = sum;
        sum = 0;
    }
}

int main() {
    const ulong[] items = [7, 8, 11, 14, 17];
    foreach (k; items) {
        ulong[] sums = new ulong[](k * 81 + 1);
        sums[0] = 1;
        sums[1] = 0;
        for (uint n = 1; n <= k; ++n) {
            for (uint i = n * 81; i >= 1; --i) {
                for (uint j = 1; j <= 9; ++j) {
                    const ulong s = j * j;
                    if (s > i)
                        break;
                    sums[i] += sums[i - s];
                }
            }
        }

        ulong count_ones = 0;
        for (uint i = 1; i <= k * 81; ++i) {
            if (ends_with_one(i)) {
                count_ones += sums[i];
            }
        }

        const ulong limit = pow(10, k) - 1;
        writefln("For k = %d in the range 1 to %d", k, limit);
        writefln("%d numbers produce 1 and %d numbers produce 89\n", count_ones, limit - count_ones);
    }

    return 0;
}
