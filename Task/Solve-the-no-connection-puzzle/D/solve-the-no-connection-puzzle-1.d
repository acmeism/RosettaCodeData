void main() @safe {
    import std.stdio, std.math, std.algorithm, std.traits, std.string;

    enum Peg { A, B, C, D, E, F, G, H }
    immutable Peg[2][15] connections =
            [[Peg.A, Peg.C], [Peg.A, Peg.D], [Peg.A, Peg.E],
             [Peg.B, Peg.D], [Peg.B, Peg.E], [Peg.B, Peg.F],
             [Peg.C, Peg.D], [Peg.D, Peg.E], [Peg.E, Peg.F],
             [Peg.G, Peg.C], [Peg.G, Peg.D], [Peg.G, Peg.E],
             [Peg.H, Peg.D], [Peg.H, Peg.E], [Peg.H, Peg.F]];

    immutable board = r"
        A   B
       /|\ /|\
      / | X | \
     /  |/ \|  \
    C - D - E - F
     \  |\ /|  /
      \ | X | /
       \|/ \|/
        G   H";

    Peg[EnumMembers!Peg.length] perm = [EnumMembers!Peg];
    do if (connections[].all!(con => abs(perm[con[0]] - perm[con[1]]) > 1))
        return board.tr("ABCDEFGH", "%(%d%)".format(perm)).writeln;
    while (perm[].nextPermutation);
}
