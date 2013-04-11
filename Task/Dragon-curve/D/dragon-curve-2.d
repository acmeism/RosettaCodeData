import std.stdio, std.string;

string drx(in size_t n) pure nothrow {
    return n ? (drx(n - 1) ~ " +" ~ dry(n - 1) ~ " f +") : "";
}

string dry(in size_t n) pure nothrow {
    return n ? (" - f" ~ drx(n - 1) ~ " -" ~ dry(n - 1)) : "";
}

string dragonCurvePS(in size_t n) pure nothrow {
    return ["0 setlinewidth 300 400 moveto",
            "/f{2 0 rlineto}def/+{90 rotate}def/-{-90 rotate}def\n",
            "f", drx(n), " stroke showpage"].join();
}

void main() {
    writeln(dragonCurvePS(9)); // Increase this for a bigger curve.
}
