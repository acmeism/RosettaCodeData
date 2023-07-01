import "dart:io";

var cache = List<int>.filled(10000, 0, growable: true);

void main() {
    cache[0] = 0;
    var count = 0;
    var i = 1;
    while (count < 20) {
        if (is_perfect_totient(i)) {
            stdout.write("$i ");
            count++;
        }
        i++;
    }
    print(" ");
}

bool is_perfect_totient(n) {
    var tot = 0;
    for (int i = 1; i < n; i++ ) {
       if (i.gcd(n) == 1) {
            tot++;
        }
    }
    int sum = tot + cache[tot];
    cache[n] = sum;
    return n == sum;
}
