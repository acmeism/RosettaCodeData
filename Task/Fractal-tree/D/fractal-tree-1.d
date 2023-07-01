import std.stdio, std.math;

enum width = 1000, height = 1000; // Image dimension.
enum length = 400;                // Trunk size.
enum scale = 6.0 / 10;            // Branch scale relative to trunk.

void tree(in double x, in double y, in double length, in double angle) {
    if (length < 1)
        return;
    immutable x2 = x + length * angle.cos;
    immutable y2 = y + length * angle.sin;
    writefln("<line x1='%f' y1='%f' x2='%f' y2='%f' " ~
             "style='stroke:black;stroke-width:1'/>", x, y, x2, y2);
    tree(x2, y2, length * scale, angle + PI / 5);
    tree(x2, y2, length * scale, angle - PI / 5);
}

void main() {
    "<svg width='100%' height='100%' version='1.1'
     xmlns='http://www.w3.org/2000/svg'>".writeln;
    tree(width / 2.0, height, length, 3 * PI / 2);
    "</svg>".writeln;
}
