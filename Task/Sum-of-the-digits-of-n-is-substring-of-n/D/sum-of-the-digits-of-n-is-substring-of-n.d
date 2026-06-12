import std.algorithm;
import std.conv;
import std.stdio;

int digitSum(int n) {
    int s = 0;
    do {
        s += n % 10;
    } while (n /= 10);
    return s;
}

void main() {
    foreach (i; 0 .. 1000) {
        if (i.to!string.canFind(digitSum(i).to!string)) {
            write(i, ' ');
        }
    }
    writeln;
}
