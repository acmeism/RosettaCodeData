import std.stdio, std.conv, std.range, std.typecons, std.bigInt;

auto rev(in BigInt n) {
    return n.text.retro.text.BigInt;
}

alias Res = Tuple!(bool, BigInt);

Res lychrel(BigInt n) {
    static Res[BigInt] cache;
    if (n in cache)
        return cache[n];

    auto r = n.rev;
    auto res = Res(true, n);
    immutable(BigInt)[] seen;
    foreach (immutable i; 0 .. 1_000) {
        n += r;
        r = n.rev;
        if (n == r) {
            res = Res(false, BigInt(0));
            break;
        }
        if (n in cache) {
            res = cache[n];
            break;
        }
        seen ~= n;
    }

    foreach (x; seen)
        cache[x] = res;
    return res;
}

void main() {
    BigInt[] seeds, related, palin;

    foreach (immutable i; BigInt(1) .. BigInt(10_000)) { // 1_000_000
        const tf_s = i.lychrel;
        if (!tf_s[0])
            continue;
        (i == tf_s[1] ? seeds : related) ~= i;
        if (i == i.rev)
            palin ~= i;
    }

    writeln(seeds.length, " Lychrel seeds: ", seeds);
    writeln(related.length, " Lychrel related");
    writeln(palin.length, " Lychrel palindromes: ", palin);
}
