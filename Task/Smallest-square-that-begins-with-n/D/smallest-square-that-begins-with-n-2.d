import std.stdio, std.range, std.conv, std.string;

// Choose an arbitrary large integer value to make sure brute forcing effective
// FYI 45_369+1 suffices for 0 < n < 50 and anything beyond will do. The output below tells...

const int upperBound = 1_000_000;

bool isTheBeginningOf(int a, int b) {
    return indexOf(to!string(b^^2), to!string(a)) == 0;
}

void main()
{
    foreach(i; iota(1, 50)) {
        foreach(j; iota(upperBound)) {
            if (isTheBeginningOf(i,j)) {
                    writefln("%4d: %4d^2 = %5d", i, j, j^^2 );
                    break;
                }
        }
    }
}
