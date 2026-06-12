import std.stdio;

bool primeDigitsSum13(int n) {
    int sum = 0;
    while (n > 0) {
        int r = n % 10;
        switch (r) {
            case 2,3,5,7:
                break;
            default:
                return false;
        }
        n /= 10;
        sum += r;
    }
    return sum == 13;
}

void main() {
    // using 2 for all digits, 6 digits is the max prior to over-shooting 13
    int c = 0;
    for (int i = 1; i < 1_000_000; i++) {
        if (primeDigitsSum13(i)) {
            writef("%6d ", i);
            if (c++ == 10) {
                c = 0;
                writeln;
            }
        }
    }
    writeln;
}
