import std.bigint;
import std.math;
import std.stdio;

void main() {
    BigInt i = 2;
    BigInt j = cast(long) floor(sqrt(cast(real) 2.0));
    BigInt k = j;
    BigInt d = j;
    int n = 500;
    int n0 = n;
    do {
        write(d);
        i = (i - k * d) * 100;
        k = 20 * j;
        for (d = 1; d <= 10; d++) {
            if ((k + d) * d > i) {
                d -= 1;
                break;
            }
        }
        j = j * 10 + d;
        k += d;
        if (n0 > 0) {
            n--;
        }
    } while (n > 0);
}
