struct Ncsub(T) {
    T[] seq;

    int opApply(int delegate(ref int[]) dg) const {
        immutable int n = seq.length;
        int result;
        auto S = new int[n];

        FOR_I:
        foreach (i; 1 .. 1 << seq.length) {
            int len_S;
            bool nc = false;
            foreach (j; 0 .. seq.length + 1) {
                immutable int k = i >> j;
                if (k == 0) {
                    if (nc) {
                        auto auxS = S[0 .. len_S];
                        result = dg(auxS);
                        if (result)
                            break FOR_I;
                    }
                    break;
                } else if (k % 2) {
                    S[len_S] = seq[j];
                    len_S++;
                } else if (len_S)
                    nc = true;
            }
        }

        return result;
    }
}

void main() {
    import std.array, std.range;
    //assert(iota(24).array().Ncsub!int().walkLength() == 16_776_915);
    auto r = array(iota(24));
    int counter;
    foreach (s; Ncsub!int(r))
        counter++;
    assert(counter == 16_776_915);
}
