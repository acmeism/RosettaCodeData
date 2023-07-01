import std.stdio;

void main() {
    write("Leonardo Numbers: ");
    leonardoNumbers( 25 );

    write("Fibonacci Numbers: ");
    leonardoNumbers( 25, 0, 1, 0 );
}

void leonardoNumbers(int count, int l0=1, int l1=1, int add=1) {
    int t;
    for (int i=0; i<count; ++i) {
        write(l0, " ");
        t = l0 + l1 + add;
        l0 = l1;
        l1 = t;
    }
    writeln();
}
