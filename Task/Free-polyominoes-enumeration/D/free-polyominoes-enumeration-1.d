import std.stdio, std.range, std.algorithm, std.typecons, std.conv;

alias Coord = int;
alias Point = Tuple!(Coord,"x", Coord,"y");
alias Polyomino = Point[];

/// Finds the min x and y coordiate of a Polyomino.
enum minima = (in Polyomino poly) pure @safe =>
    Point(poly.map!q{ a.x }.reduce!min, poly.map!q{ a.y }.reduce!min);

Polyomino translateToOrigin(in Polyomino poly) {
    const minP = poly.minima;
    return poly.map!(p => Point(cast(Coord)(p.x - minP.x), cast(Coord)(p.y - minP.y))).array;
}

enum Point function(in Point p) pure nothrow @safe @nogc
    rotate90  = p => Point( p.y, -p.x),
    rotate180 = p => Point(-p.x, -p.y),
    rotate270 = p => Point(-p.y,  p.x),
    reflect   = p => Point(-p.x,  p.y);

/// All the plane symmetries of a rectangular region.
auto rotationsAndReflections(in Polyomino poly) pure nothrow {
    return only(poly,
                poly.map!rotate90.array,
                poly.map!rotate180.array,
                poly.map!rotate270.array,
                poly.map!reflect.array,
                poly.map!(pt => pt.rotate90.reflect).array,
                poly.map!(pt => pt.rotate180.reflect).array,
                poly.map!(pt => pt.rotate270.reflect).array);
}

enum canonical = (in Polyomino poly) =>
    poly.rotationsAndReflections.map!(pl => pl.translateToOrigin.sort().release).reduce!min;

auto unique(T)(T[] seq) pure nothrow {
    return seq.sort().uniq;
}

/// All four points in Von Neumann neighborhood.
enum contiguous = (in Point pt) pure nothrow @safe @nogc =>
    only(Point(cast(Coord)(pt.x - 1), pt.y), Point(cast(Coord)(pt.x + 1), pt.y),
         Point(pt.x, cast(Coord)(pt.y - 1)), Point(pt.x, cast(Coord)(pt.y + 1)));

/// Finds all distinct points that can be added to a Polyomino.
enum newPoints = (in Polyomino poly) nothrow =>
    poly.map!contiguous.joiner.filter!(pt => !poly.canFind(pt)).array.unique;

enum newPolys = (in Polyomino poly) =>
    poly.newPoints.map!(pt => canonical(poly ~ pt)).array.unique;

/// Generates polyominoes of rank n recursively.
Polyomino[] rank(in uint n) {
    static immutable Polyomino monomino = [Point(0, 0)];
    static Polyomino[] monominoes = [monomino]; // Mutable.
    if (n == 0) return [];
    if (n == 1) return monominoes;
    return rank(n - 1).map!newPolys.join.unique.array;
}

/// Generates a textual representation of a Polyomino.
char[][] textRepresentation(in Polyomino poly) pure @safe {
    immutable minPt = poly.minima;
    immutable maxPt = Point(poly.map!q{ a.x }.reduce!max, poly.map!q{ a.y }.reduce!max);
    auto table = new char[][](maxPt.y - minPt.y + 1, maxPt.x - minPt.x + 1);
    foreach (row; table)
        row[] = ' ';
    foreach (immutable pt; poly)
        table[pt.y - minPt.y][pt.x - minPt.x] = '#';
    return table;
}

void main(in string[] args) {
    iota(1, 11).map!(n => n.rank.length).writeln;

    immutable n = (args.length == 2) ? args[1].to!uint : 5;
    writefln("\nAll free polyominoes of rank %d:", n);

    foreach (const poly; n.rank)
        writefln("%-(%s\n%)\n", poly.textRepresentation);
}
