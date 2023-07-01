import std.stdio;

/// 2D spiral generator
const struct Spiral {
    int w, h;

    int opApply(int delegate(ref int, ref int, ref int) dg) {
        int idx, x, y, xy, dx = 1, dy;
        int[] subLen = [w, h-1];

        void turn() {
            auto t = -dy;
            dy = dx;
            dx = t;
            xy = 1 - xy;
        }

        void forward(int d = 1) {
            x += d * dx;
            y += d * dy;
            idx += d;
        }

        Bye:
        while (true) {
            if (subLen[xy] == 0)
                break;
            foreach (_; 0 .. subLen[xy]--)
                if (dg(idx, x, y))
                    break Bye;
                else
                    forward();
            forward(-1);
            turn();
            forward();
        }

        return 0;
    }
}

int[][] spiralMatrix(int w, int h) {
    auto m = new typeof(return)(h, w);
    foreach (value, x, y; Spiral(w, h))
        m[y][x] = value;
    return m;
}

void main() {
    foreach (r; spiralMatrix(9, 4))
        writefln("%(%2d %)", r);
}
