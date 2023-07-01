import std.stdio, std.algorithm, std.traits, grayscale_image;

void main() {
    enum width = 100, height = 100;
    enum nSteps = 12_000;
    enum Direction { up, right, down, left }
    auto M = new Image!Gray(width, height);
    M.clear(Gray.white);
    uint x = width / 2, y = height / 2;
    auto dir = Direction.up;

    for (int i = 0; i < nSteps && x < width && y < height; i++) {
        immutable turn = M[x, y] == Gray.black;
        dir = [EnumMembers!Direction][(dir + (turn ? 1 : -1)) & 3];
        M[x, y] = (M[x, y] == Gray.black) ? Gray.white : Gray.black;
        final switch(dir) with (Direction) {
            case up:    y--; break;
            case right: x--; break;
            case down:  y++; break;
            case left:  x++; break;
        }
    }

    M.savePGM("langton_ant.pgm");
}
