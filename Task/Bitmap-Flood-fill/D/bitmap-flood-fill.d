import std.array, bitmap;

void floodFill(Color)(Image!Color img, in uint x, in uint y,
                      in Color color)
/*pure nothrow*/ in {
    assert (y < img.ny && x < img.nx);
} body {
    immutable target = img[x, y];
    static struct Pos { uint x, y; }
    auto stack = [Pos(x, y)];

    while (!stack.empty) {
        immutable p = stack.back;
        stack.popBack();
        if (p.y < img.ny && p.x < img.nx && img[p.x, p.y] == target) {
            img[p.x, p.y] = color;
            stack.assumeSafeAppend(); // Not pure nor nothrow.
            stack ~= Pos(p.x - 1, p.y);
            stack ~= Pos(p.x + 1, p.y);
            stack ~= Pos(p.x,     p.y - 1);
            stack ~= Pos(p.x,     p.y + 1);
        }
    }
}

void main() {
    auto img = new Image!RGB();
    img.loadPPM6("Unfilledcirc.ppm");
    img.floodFill(200, 200, RGB(127, 0, 0));
    img.savePPM6("Unfilledcirc_flooded.ppm");
}
