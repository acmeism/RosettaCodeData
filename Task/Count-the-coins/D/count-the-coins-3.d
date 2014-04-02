import std.stdio, std.bigint, std.algorithm, std.conv, std.functional;

struct Ucent { /// Simplified 128-bit integer (like ucent).
    ulong hi, lo;
    static immutable one = Ucent(0, 1);

    void opOpAssign(string op="+")(in ref Ucent y) pure nothrow {
        this.hi += y.hi;
        if (this.lo >= ~y.lo)
            this.hi++;
        this.lo += y.lo;
    }

    const string toString() const /*pure nothrow*/ {
        return text((this.hi.BigInt << 64) + this.lo);
    }
}

Ucent countChanges(in int amount, in int[] coins) pure nothrow {
    immutable n = coins.length;

    // Points to a cyclic buffer of length coins[i]
    auto p = new Ucent*[n];
    auto q = new Ucent*[n]; // iterates it.
    auto buf = new Ucent[coins.sum];

    p[0] = buf.ptr;
    foreach (immutable i; 0 .. n) {
        if (i)
            p[i] = coins[i - 1] + p[i - 1];
        *p[i] = Ucent.one;
        q[i] = p[i];
    }

    Ucent prev;
    foreach (immutable j; 1 .. amount + 1)
        foreach (immutable i; 0 .. n) {
            q[i]--;
            if (q[i] < p[i])
                q[i] = p[i] + coins[i] - 1;
            if (i)
                *q[i] += prev;
            prev = *q[i];
        }

    return prev;
}

void main() {
    immutable usCoins = [100, 50, 25, 10, 5, 1];
    immutable euCoins = [200, 100, 50, 20, 10, 5, 2, 1];

    foreach (immutable coins; [usCoins, euCoins]) {
        countChanges(     1_00, coins[2 .. $]).writeln;
        countChanges(  1000_00, coins).writeln;
        countChanges( 10000_00, coins).writeln;
        countChanges(100000_00, coins).writeln;
        writeln;
    }
}
