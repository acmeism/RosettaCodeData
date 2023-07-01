import std.stdio, std.algorithm, std.string, std.functional,
       std.typecons, std.typetuple, bitmap;

struct BlackWhite {
    ubyte c;
    alias c this;
    static immutable black = typeof(this)(0),
                     white = typeof(this)(1);
}

alias Neighbours = BlackWhite[9];
alias Img = Image!BlackWhite;

/// Zhang-Suen thinning algorithm.
Img zhangSuen(Img image1, Img image2) pure nothrow @safe @nogc
in {
    assert(image1.image.all!(x => x == Img.black || x == Img.white));
    assert(image1.nx == image2.nx && image1.ny == image2.ny);
} out(result) {
    assert(result.nx == image1.nx && result.ny == image1.ny);
    assert(result.image.all!(x => x == Img.black || x == Img.white));
} body {
    /// True if inf <= x <= sup.
    static inInterval(T)(in T x, in T inf, in T sup) pure nothrow @safe @nogc {
        return x >= inf && x <= sup;
    }

    /// Return 8-neighbours+1 of point (x,y) of given image, in order.
    static void neighbours(in Img I, in size_t x, in size_t y,
                           out Neighbours n) pure nothrow @safe @nogc {
        n = [I[x,y-1], I[x+1,y-1], I[x+1,y], I[x+1,y+1], // P2,P3,P4,P5
             I[x,y+1], I[x-1,y+1], I[x-1,y], I[x-1,y-1], // P6,P7,P8,P9
             I[x,y-1]];
    }

    if (image1.nx < 3 || image1.ny < 3) {
        image2.image[] = image1.image[];
        return image2;
    }

    immutable static zeroOne = [0, 1]; //**
    Neighbours n;
    bool hasChanged;
    do {
        hasChanged = false;

        foreach (immutable ab; TypeTuple!(tuple(2, 4), tuple(0, 6))) {
            foreach (immutable y; 1 .. image1.ny - 1) {
                foreach (immutable x; 1 .. image1.nx - 1) {
                    neighbours(image1, x, y, n);
                    if (image1[x, y] &&                    // Cond. 0
                        (!n[ab[0]] || !n[4] || !n[6]) &&   // Cond. 4
                        (!n[0] || !n[2] || !n[ab[1]]) &&   // Cond. 3
                        //n[].count([0, 1]) == 1 &&
                        n[].count(zeroOne) == 1 &&         // Cond. 2
                        // n[0 .. 8].sum in iota(2, 7)) {
                        inInterval(n[0 .. 8].sum, 2, 6)) { // Cond. 1
                        hasChanged = true;
                        image2[x, y] = Img.black;
                    } else
                        image2[x, y] = image1[x, y];
                }
            }
            image1.swap(image2);
        }
    } while (hasChanged);

    return image1;
}

void main() {
    immutable before_txt = "
    ##..###
    ##..###
    ##..###
    ##..###
    ##..##.
    ##..##.
    ##..##.
    ##..##.
    ##..##.
    ##..##.
    ##..##.
    ##..##.
    ######.
    .......";

    immutable small_rc = "
    ................................
    .#########.......########.......
    .###...####.....####..####......
    .###....###.....###....###......
    .###...####.....###.............
    .#########......###.............
    .###.####.......###....###......
    .###..####..###.####..####.###..
    .###...####.###..########..###..
    ................................";

    immutable rc = "
    ...........................................................
    .#################...................#############.........
    .##################...............################.........
    .###################............##################.........
    .########.....#######..........###################.........
    ...######.....#######.........#######.......######.........
    ...######.....#######........#######.......................
    ...#################.........#######.......................
    ...################..........#######.......................
    ...#################.........#######.......................
    ...######.....#######........#######.......................
    ...######.....#######........#######.......................
    ...######.....#######.........#######.......######.........
    .########.....#######..........###################.........
    .########.....#######.######....##################.######..
    .########.....#######.######......################.######..
    .########.....#######.######.........#############.######..
    ...........................................................";

    foreach (immutable txt; [before_txt, small_rc, rc]) {
        auto img = Img.fromText(txt);
        "From:".writeln;
        img.textualShow(/*bl=*/ '.', /*wh=*/ '#');
        "\nTo thinned:".writeln;
        img.zhangSuen(img.dup).textualShow(/*bl=*/ '.', /*wh=*/ '#');
        writeln;
    }
}
