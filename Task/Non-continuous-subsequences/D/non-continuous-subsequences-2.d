struct Ncsub(T) {
    T[] seq;

    int opApply(int delegate(ref T[]) dg) const {
        immutable n = seq.length;
        int result;
        auto S = new T[n];

        OUTER: foreach (immutable i; 1 .. 1 << n) {
            uint lenS;
            bool nc = false;
            foreach (immutable j; 0 .. n + 1) {
                immutable k = i >> j;
                if (k == 0) {
                    if (nc) {
                        auto auxS = S[0 .. lenS];
                        result = dg(auxS);
                        if (result)
                            break OUTER;
                    }
                    break;
                } else if (k % 2) {
                    S[lenS] = seq[j];
                    lenS++;
                } else if (lenS)
                    nc = true;
            }
        }

        return result;
    }
}

void main() {
    import std.array, std.range;

    //assert(24.iota.array.Ncsub!int.walkLength == 16_776_915);
    auto r = 24.iota.array;
    uint counter = 0;
    foreach (s; Ncsub!int(r))
        counter++;
    assert(counter == 16_776_915);
}
