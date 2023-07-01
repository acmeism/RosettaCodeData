import std.math;
import std.stdio;

struct PCG32 {
private:
    immutable ulong N = 6364136223846793005;
    ulong state = 0x853c49e6748fea9b;
    ulong inc = 0xda3e39cb94b95bdb;

public:
    void seed(ulong seed_state, ulong seed_sequence) {
        state = 0;
        inc = (seed_sequence << 1) | 1;
        nextInt();
        state = state + seed_state;
        nextInt();
    }

    uint nextInt() {
        ulong old = state;
        state = old * N + inc;
        uint shifted = cast(uint)(((old >> 18) ^ old) >> 27);
        uint rot = old >> 59;
        return (shifted >> rot) | (shifted << ((~rot + 1) & 31));
    }

    double nextFloat() {
        return (cast(double) nextInt()) / (1L << 32);
    }
}

void main() {
    auto r = PCG32();

    r.seed(42, 54);
    writeln(r.nextInt());
    writeln(r.nextInt());
    writeln(r.nextInt());
    writeln(r.nextInt());
    writeln(r.nextInt());
    writeln;

    auto counts = [0, 0, 0, 0, 0];
    r.seed(987654321, 1);
    foreach (_; 0..100_000) {
        int j = cast(int)floor(r.nextFloat() * 5.0);
        counts[j]++;
    }

    writeln("The counts for 100,000 repetitions are:");
    foreach (i,v; counts) {
        writeln("  ", i, " : ", v);
    }
}
