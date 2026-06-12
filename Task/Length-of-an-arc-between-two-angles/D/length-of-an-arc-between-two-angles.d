import std.math;
import std.stdio;

double arcLength(double radius, double angle1, double angle2) {
    return (360.0 - abs(angle2 - angle1)) * PI * radius / 180.0;
}

void main() {
    writeln("arc length: ", arcLength(10.0, 10.0, 120.0));
}
