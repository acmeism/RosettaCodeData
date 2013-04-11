import std.stdio, std.math, std.conv, std.string;

double radians(double x) { return x * (PI/180); }
double degrees(double x) { return x / (PI/180); }

T input(T)(string msg) {
    write(msg);
    return to!T(readln().strip());
}

void main() {
    double lat = input!double("Enter latitude       => ");
    double lng = input!double("Enter longitude      => ");
    double lme = input!double("Enter legal meridian => ");
    writeln();

    double slat = sin(radians(lat));
    writefln("    sine of latitude:   %.3f", slat);
    writefln("    diff longitude:     %.3f", lng-lme);
    writeln();
    writeln("Hour, sun hour angle, dial hour line angle from 6am to 6pm");

    foreach (h; -6 .. 7) {
        double hra = 15 * h;
        hra -= (lng - lme);
        double hla = degrees(atan(slat * tan(radians(hra))));
        writefln("HR=%3d; HRA=%7.3f; HLA=%7.3f", h, hra, hla);
    }
}
