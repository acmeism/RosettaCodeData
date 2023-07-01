import std.stdio;

void main() {
    auto sizes = [8, 24, 52, 100, 1020, 1024, 10_000];
    foreach(s; sizes) {
        writefln("%5s : %5s", s, perfectShuffle(s));
    }
}

int perfectShuffle(int size) {
    import std.exception : enforce;
    enforce(size%2==0);

    import std.algorithm : copy, equal;
    import std.range;
    int[] orig = iota(0, size).array;

    int[] process;
    process.length = size;
    copy(orig, process);

    for(int count=1; true; count++) {
        process = roundRobin(process[0..$/2], process[$/2..$]).array;

        if (equal(orig, process)) {
            return count;
        }
    }

    assert(false, "How did this get here?");
}
