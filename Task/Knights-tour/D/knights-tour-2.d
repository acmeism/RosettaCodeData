import std.stdio, std.math, std.algorithm, std.range, std.typecons;

alias Square = Tuple!(int,"x", int,"y");

const(Square)[] knightTour(in Square[] board, in Square[] moves) pure @safe nothrow {
    enum findMoves = (in Square sq) pure nothrow @safe =>
        cartesianProduct([1, -1, 2, -2], [1, -1, 2, -2])
        .filter!(ij => ij[0].abs != ij[1].abs)
        .map!(ij => Square(sq.x + ij[0], sq.y + ij[1]))
        .filter!(s => board.canFind(s) && !moves.canFind(s));
    auto newMoves = findMoves(moves.back);
    if (newMoves.empty)
        return moves;
    //alias warnsdorff = min!(s => findMoves(s).walkLength);
    //immutable newSq = newMoves.dropOne.fold!warnsdorff(newMoves.front);
    auto pairs = newMoves.map!(s => tuple(findMoves(s).walkLength, s));
    immutable newSq = reduce!min(pairs.front, pairs.dropOne)[1];
    return board.knightTour(moves ~ newSq);
}

void main(in string[] args) {
    enum toSq = (in string xy) => Square(xy[0] - '`', xy[1] - '0');
    immutable toAlg = (in Square s) => [dchar(s.x + '`'), dchar(s.y + '0')];
    immutable sq = toSq((args.length == 2) ? args[1] : "e5");
    const board = iota(1, 9).cartesianProduct(iota(1, 9)).map!Square.array;
    writefln("%(%-(%s -> %)\n%)", board.knightTour([sq]).map!toAlg.chunks(8));
}
