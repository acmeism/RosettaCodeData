import std.stdio, std.bigint, std.conv;

struct Narcissistics(TNum, uint maxLen) {
    TNum[10] power;
    TNum[maxLen + 1] dsum;
    uint[10] count;
    uint len;

    void checkPerm() const {
        uint[10] mout;

        immutable s = dsum[0].text;
        foreach (immutable d; s) {
            immutable c = d - '0';
            if (++mout[c] > count[c])
                return;
        }

        if (s.length == len)
            writef(" %d", dsum[0]);
    }

    void narc2(in uint pos, uint d) {
        if (!pos) {
            checkPerm;
            return;
        }

        do {
            dsum[pos - 1] = dsum[pos] + power[d];
            count[d]++;
            narc2(pos - 1, d);
            count[d]--;
        } while (d--);
    }

    void show(in uint n) {
        len = n;
        foreach (immutable i, ref p; power)
            p = TNum(i) ^^ n;
        dsum[n] = 0;
        writef("length %d:", n);
        narc2(n, 9);
        writeln;
    }
}

void main() {
    enum maxLength = 16;
    Narcissistics!(ulong, maxLength) narc;
    //Narcissistics!(BigInt, maxLength) narc; // For larger numbers.
    foreach (immutable i; 1 .. maxLength + 1)
        narc.show(i);
}
