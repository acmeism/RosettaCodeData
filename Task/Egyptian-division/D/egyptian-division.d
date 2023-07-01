import std.stdio;

version(unittest) {
    // empty
} else {
    int main(string[] args) {
        import std.conv;

        if (args.length < 3) {
            stderr.writeln("Usage: ", args[0], " dividend divisor");
            return 1;
        }

        ulong dividend = to!ulong(args[1]);
        ulong divisor = to!ulong(args[2]);
        ulong remainder;

        auto ans = egyptian_division(dividend, divisor, remainder);
        writeln(dividend, " / ", divisor, " = ", ans, " rem ", remainder);

        return 0;
    }
}

ulong egyptian_division(ulong dividend, ulong divisor, out ulong remainder) {
    enum SIZE = 64;
    ulong[SIZE] powers;
    ulong[SIZE] doublings;
    int i;

    for (; i<SIZE; ++i) {
        powers[i] = 1 << i;
        doublings[i] = divisor << i;
        if (doublings[i] > dividend) {
            break;
        }
    }

    ulong answer;
    ulong accumulator;

    for (i=i-1; i>=0; --i) {
        if (accumulator + doublings[i] <= dividend) {
            accumulator += doublings[i];
            answer += powers[i];
        }
    }

    remainder = dividend - accumulator;
    return answer;
}

unittest {
    ulong remainder;

    assert(egyptian_division(580UL, 34UL, remainder) == 17UL);
    assert(remainder == 2);
}
