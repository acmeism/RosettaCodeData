import std.math;
import std.stdio;

class XorShiftStar {
    private immutable MAGIC = 0x2545F4914F6CDD1D;
    private ulong state;

    public void seed(ulong num) {
        state = num;
    }

    public uint nextInt() {
        ulong x;
        uint answer;

        x = state;
        x = x ^ (x >> 12);
        x = x ^ (x << 25);
        x = x ^ (x >> 27);
        state = x;
        answer = ((x * MAGIC) >> 32);

        return answer;
    }

    public float nextFloat() {
        return cast(float) nextInt() / (1L << 32);
    }
}

void main() {
    auto rng = new XorShiftStar();
    rng.seed(1234567);
    writeln(rng.nextInt);
    writeln(rng.nextInt);
    writeln(rng.nextInt);
    writeln(rng.nextInt);
    writeln(rng.nextInt);
    writeln;

    int[5] counts;
    rng.seed(987654321);
    foreach (_; 0 .. 100_000) {
        auto j = cast(int) floor(rng.nextFloat * 5.0);
        counts[j]++;
    }
    foreach (i, v; counts) {
        writeln(i, ": ", v);
    }
}
