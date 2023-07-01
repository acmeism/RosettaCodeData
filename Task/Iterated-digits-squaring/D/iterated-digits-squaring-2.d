void main() nothrow @nogc {
    import core.stdc.stdio: printf;

    enum uint magic = 89;
    enum uint limit = 100_000_000;
    uint[(9 ^^ 2) * 8 + 1] lookup = void;

    uint[10] squares;
    foreach (immutable i, ref x; squares)
        x = i ^^ 2;

    foreach (immutable uint i; 1 .. lookup.length) {
        uint x = i;

        while (x != magic && x != 1) {
            uint total = 0;
            while (x) {
                total += squares[(x % 10)];
                x /= 10;
            }
            x = total;
        }

        lookup[i] = x == magic;
    }

    uint magicCount = 0;
    foreach (immutable uint i; 1 .. limit) {
        uint x = i;
        uint total = 0;

        while (x) {
            total += squares[(x % 10)];
            x /= 10;
        }

        magicCount += lookup[total];
    }

    printf("%u\n", magicCount);
}
