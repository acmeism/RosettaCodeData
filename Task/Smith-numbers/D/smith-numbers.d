import std.stdio;

void main() {
    int cnt;
    for (int n=1; n<10_000; n++) {
        auto factors = primeFactors(n);
        if (factors.length > 1) {
            int sum = sumDigits(n);
            foreach (f; factors) {
                sum -= sumDigits(f);
            }
            if (sum==0) {
                writef("%4s  ", n);
                cnt++;
            }
            if (cnt==10) {
                cnt = 0;
                writeln();
            }
        }
    }
}

auto primeFactors(int n) {
    import std.array : appender;
    auto result = appender!(int[]);

    for (int i=2; n%i==0; n/=i) {
        result.put(i);
    }

    for (int i=3; i*i<=n; i+=2) {
        while (n%i==0) {
            result.put(i);
            n/=i;
        }
    }

    if (n!=1) {
        result.put(n);
    }

    return result.data;
}

int sumDigits(int n) {
    int sum;
    while (n > 0) {
        sum += (n%10);
        n /= 10;
    }
    return sum;
}
