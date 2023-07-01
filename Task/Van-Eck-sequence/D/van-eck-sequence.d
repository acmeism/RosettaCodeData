import std.stdio;

void vanEck(int firstIndex, int lastIndex) {
    int[int] vanEckMap;
    int last = 0;
    if (firstIndex == 1) {
        writefln("VanEck[%d] = %d", 1, 0);
    }
    for (int n = 2; n <= lastIndex; n++) {
        int vanEck = last in vanEckMap ? n - vanEckMap[last] : 0;
        vanEckMap[last] = n;
        last = vanEck;
        if (n >= firstIndex) {
            writefln("VanEck[%d] = %d", n, vanEck);
        }
    }
}

void main() {
    writeln("First 10 terms of Van Eck's sequence:");
    vanEck(1, 10);
    writeln;
    writeln("Terms 991 to 1000 of Van Eck's sequence:");
    vanEck(991, 1000);
}
