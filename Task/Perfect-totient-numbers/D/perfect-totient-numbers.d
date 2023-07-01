import std.stdio;
import std.numeric;

int[10000] cache;

bool is_perfect_totient(int num) {
    int tot = 0;
    for (int i = 1; i < num; i++) {
        if (gcd(num, i) == 1) {
            tot++;
        }
    }
    int sum = tot + cache[tot];
    cache[num] = sum;
    return num == sum;
}

void main() {
    int j = 1;
    int count = 0;
    while (count < 20) {
        if (is_perfect_totient(j)) {
            printf("%d ", j);
            count++;
        }
        j++;
    }
    writeln(" ");
}
