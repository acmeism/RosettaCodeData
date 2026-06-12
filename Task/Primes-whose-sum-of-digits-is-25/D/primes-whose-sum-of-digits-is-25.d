import std.bigint;
import std.stdio;

bool isPrime(BigInt n) {
    if (n < 2) {
        return false;
    }

    if (n % 2 == 0) {
        return n == 2;
    }
    if (n % 3 == 0) {
        return n == 3;
    }

    auto i = BigInt(5);
    while (i * i <= n) {
        if (n % i == 0){
            return false;
        }
        i += 2;

        if (n % i == 0){
            return false;
        }
        i += 4;
    }

    return true;
}

int digitSum(BigInt n) {
    int result;
    while (n > 0) {
        result += n % 10;
        n /= 10;
    }
    return result;
}

void main() {
    for (auto n = BigInt(2); n < 5_000; n++) {
        if (n.isPrime && n.digitSum == 25) {
            write(n, ' ');
        }
    }
    writeln;
}
