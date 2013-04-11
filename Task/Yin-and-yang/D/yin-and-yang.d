import std.stdio, std.string, std.algorithm, std.array;

struct SquareBoard {
    enum W : char { Void=' ', Yan='.', Yin='#', I='?' }

    immutable int scale;
    W[][] pix;

    this(in int s) pure nothrow {
        scale = s;
        pix = new typeof(pix)(s * 12 + 1, s * 12 + 1);
    }

    string toString() const /*pure nothrow*/ {
        auto rows = pix.map!q{ (cast(char[])a).idup }();
        return rows.join("\n");
    }

    void drawCircle(Draw)(in int cx, in int cy, in int cr,
                          Draw action)
pure nothrow {
        immutable rr = (cr * scale) ^^ 2;
        foreach (y, ref r; pix)
            foreach (x, ref v; r) {
                immutable dx = x - cx * scale;
                immutable dy = y - cy * scale;
                if (dx ^^ 2 + dy ^^ 2 <= rr)
                    v = action(x);
            }
    }

    SquareBoard yanYin() pure nothrow {
        foreach (r; pix) // clear
            r[] = W.Void;
        drawCircle(6, 6, 6, (int x) => (x < 6 * scale) ? W.Yan : W.Yin);
        drawCircle(6, 3, 3, (int x) => W.Yan);
        drawCircle(6, 9, 3, (int x) => W.Yin);
        drawCircle(6, 9, 1, (int x) => W.Yan);
        drawCircle(6, 3, 1, (int x) => W.Yin);
        return this;
    }
}

void main() {
    writeln(SquareBoard(2).yanYin());
    writeln(SquareBoard(1).yanYin());
}
