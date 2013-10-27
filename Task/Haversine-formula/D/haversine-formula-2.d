import std.stdio, std.math;

real toRad(real degrees) {
    return degrees * PI / 180;
}

real haversin(real theta) {
    return (1 - cos(theta)) / 2;
}

real greatCircleDistance(real lat1, real lng1,
                         real lat2, real lng2, real radius) {
    real h = haversin(lat2.toRad - lat1.toRad) +
                cos(lat1.toRad) * cos(lat2.toRad) *
                haversin(lng2.toRad - lng1.toRad);
    return 2 * radius * asin(sqrt(h));
}

void main() {
    const real earthRadius = 6372.8;   // average earth radius

    writefln("Great circle distance: %.1f km",
             greatCircleDistance(36.12, -86.67, 33.94, -118.4, earthRadius));
}
