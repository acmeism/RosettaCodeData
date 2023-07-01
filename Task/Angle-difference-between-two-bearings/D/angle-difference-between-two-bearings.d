import std.stdio;

double getDifference(double b1, double b2) {
    double r = (b2 - b1) % 360.0;
    if (r < -180.0) {
        r += 360.0;
    }
    if (r >= 180.0) {
        r -= 360.0;
    }
    return r;
}

void main() {
    writeln("Input in -180 to +180 range");
    writeln(getDifference(20.0, 45.0));
    writeln(getDifference(-45.0, 45.0));
    writeln(getDifference(-85.0, 90.0));
    writeln(getDifference(-95.0, 90.0));
    writeln(getDifference(-45.0, 125.0));
    writeln(getDifference(-45.0, 145.0));
    writeln(getDifference(-45.0, 125.0));
    writeln(getDifference(-45.0, 145.0));
    writeln(getDifference(29.4803, -88.6381));
    writeln(getDifference(-78.3251, -159.036));

    writeln("Input in wider range");
    writeln(getDifference(-70099.74233810938, 29840.67437876723));
    writeln(getDifference(-165313.6666297357, 33693.9894517456));
    writeln(getDifference(1174.8380510598456, -154146.66490124757));
    writeln(getDifference(60175.77306795546, 42213.07192354373));
}
