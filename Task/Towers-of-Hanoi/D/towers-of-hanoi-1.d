import std.stdio;

void hanoi(in int n, in char from, in char to, in char via) {
    if (n > 0) {
        hanoi(n - 1, from, via, to);
        writefln("Move disk %d from %s to %s", n, from, to);
        hanoi(n - 1, via, to, from);
    }
}

void main() {
    hanoi(3, 'L', 'M', 'R');
}
