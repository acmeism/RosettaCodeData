import std.stdio, std.math;

real toRad(in real degrees) pure nothrow @safe @nogc {
    return degrees * PI / 180;
}

real haversin(in real theta) pure nothrow @safe @nogc {
    return (1 - theta.cos) / 2;
}

real greatCircleDistance(in real lat1, in real lng1,
                         in real lat2, in real lng2,
                         in real radius)
pure nothrow @safe @nogc {
    immutable h = haversin(lat2.toRad - lat1.toRad) +
                  lat1.toRad.cos * lat2.toRad.cos *
                  haversin(lng2.toRad - lng1.toRad);
    return 2 * radius * h.sqrt.asin;
}

void main() {
    enum real earthRadius = 6372.8L; // Average earth radius.

    writefln("Great circle distance: %.1f km",
             greatCircleDistance(36.12, -86.67, 33.94, -118.4,
                                 earthRadius));
}
