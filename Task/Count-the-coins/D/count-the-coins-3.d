import std.stdio, std.bigint, std.algorithm, std.conv;

struct Ucent { /// Simplified 128-bit integer (like ucent).
    ulong hi, lo;
    static immutable one = Ucent(0, 1);

    void opOpAssign(string op="+")(in ref Ucent y) pure nothrow {
        this.hi += y.hi;
        if (this.lo >= ~y.lo)
            this.hi++;
        this.lo += y.lo;
    }

    const string toString() const {
        return text((BigInt(this.hi) << 64) + this.lo);
    }
}

Ucent countChanges(in int amount, in int[] coins) pure /*nothrow*/ {
    immutable n = coins.length;

    // points to a cyclic buffer of length coins[i]
    auto p = (new Ucent*[n]).ptr;
    auto q = (new Ucent*[n]).ptr; // iterates it.
    //auto buf = new Ucent[sum(coins)];
    auto buf = new Ucent[reduce!q{ a + b }(0, coins)]; // not nothrow

    p[0] = buf.ptr;
    foreach (i; 0 .. n) {
        if (i)
            p[i] = coins[i - 1] + p[i - 1];
        *p[i] = Ucent.one;
        q[i] = p[i];
    }

    Ucent prev;
    foreach (j; 1 .. amount + 1)
        foreach (i; 0 .. n) {
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

    foreach (coins; [usCoins, euCoins]) {
        writeln(countChanges(     1_00, coins[2 .. $]));
        writeln(countChanges(  1000_00, coins));
        writeln(countChanges( 10000_00, coins));
        writeln(countChanges(100000_00, coins), "\n");
    }
}
