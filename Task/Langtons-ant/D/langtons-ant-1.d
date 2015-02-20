void main() @safe {
    import std.stdio, std.traits;

    enum width = 75, height = 52;
    enum maxSteps = 12_000;
    enum Direction { up, right, down, left }
    enum Color : char { white = '.', black = '#' }
    uint x = width / 2, y = height / 2;
    Color[width][height] M;
    auto dir = Direction.up;

    with (Color)
        for (int i = 0; i < maxSteps && x < width && y < height; i++) {
            immutable turn = M[y][x] == black;
            dir = [EnumMembers!Direction][(dir + (turn ? 1 : -1)) & 3];
            M[y][x] = (M[y][x] == black) ? white : black;
            final switch(dir) with (Direction) {
                case up:    y--; break;
                case right: x--; break;
                case down:  y++; break;
                case left:  x++; break;
            }
        }

    writefln("%(%-(%c%)\n%)", M);
}
