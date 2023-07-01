module turtle;

import bitmap_bresenhams_line_algorithm, grayscale_image, std.math;

// Minimal turtle graphics.
struct Turtle {
    real x = 100, y = 100, angle = -90;

    void left(in real a) pure nothrow { angle -= a; }
    void right(in real a) pure nothrow { angle += a; }

    void forward(Color)(Image!Color img, in real len) pure nothrow {
        immutable r = angle * (PI / 180.0);
        immutable dx = r.cos * len;
        immutable dy = r.sin * len;
        img.drawLine(cast(uint)x, cast(uint)y,
                     cast(uint)(x + dx), cast(uint)(y + dy),
                     Color.white);
        x += dx;
        y += dy;
    }
}
