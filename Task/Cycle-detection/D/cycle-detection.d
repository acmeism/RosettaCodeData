import std.range;
import std.stdio;

void main() {
    brent(i => (i * i + 1) % 255, 3);
}

void brent(int function(int) f, int x0) {
    int cycleLength;
    int hare = x0;
    FOUND:
    for (int power = 1; ; power *= 2) {
        int tortoise = hare;
        for (int i = 1; i <= power; i++) {
            hare = f(hare);
             if (tortoise == hare) {
                cycleLength = i;
                break FOUND;
            }
        }
    }

    hare = x0;
    for (int i = 0; i < cycleLength; i++)
        hare = f(hare);

    int cycleStart = 0;
    for (int tortoise = x0; tortoise != hare; cycleStart++) {
        tortoise = f(tortoise);
        hare = f(hare);
    }

    printResult(x0, f, cycleLength, cycleStart);
}

void printResult(int x0, int function(int) f, int len, int start) {
    writeln("Cycle length: ", len);
    writefln("Cycle: %(%s %)", iterate(x0, f).drop(start).take(len));
}

auto iterate(int start, int function(int) f) {
    return only(start).chain(generate!(() => start=f(start)));
}
