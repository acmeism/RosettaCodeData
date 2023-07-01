import std.stdio;
import std.math;
import std.conv;

bool is_disarium(int num) {
    int n = num;
    int sum = 0;
    ulong len = to!string(num, 10).length;
    while (n > 0) {
        sum += pow(n % 10, len);
        n /= 10;
        len--;
    }
    return num == sum;
}
void main() {
    int i = 0;
    int count = 0;
    while (count < 19) {
        if (is_disarium(i)) {
            printf("%d ", i);
            count++;
        }
        i++;
    }
    writeln(" ");
}
