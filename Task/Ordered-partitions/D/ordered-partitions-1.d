import std.stdio, std.algorithm, std.range, std.array, std.conv,
       combinations3;

alias iRNG = int[];

iRNG[][] orderPart(iRNG blockSize...) {
    iRNG tot = iota(1, 1 + blockSize.sum).array;

    iRNG[][] p(iRNG s, in iRNG b) {
        if (b.empty)
            return [[]];
        iRNG[][] res;
        foreach (c; s.combinations(b[0]))
            foreach (r; p(setDifference(s, c).array, b.dropOne))
                res ~= c.dup ~ r;
        return res;
    }

    return p(tot, blockSize);
}

void main(in string[] args) {
    auto b = args.length > 1 ? args.dropOne.to!(int[]) : [2, 0, 2];
    writefln("%(%s\n%)", b.orderPart);
}
