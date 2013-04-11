import std.stdio, std.math;

void main() {
    enum real degrees = 45.0;
    enum real t0 = degrees * PI / 180.0;
    writeln("Reference:  0.7071067811865475244008");
    writefln("Sine:       %.20f  %.20f", sin(PI_4), sin(t0));
    writefln("Cosine:     %.20f  %.20f", cos(PI_4), cos(t0));
    writefln("Tangent:    %.20f  %.20f", tan(PI_4), tan(t0));

    writeln();
    writeln("Reference:  0.7853981633974483096156");
    immutable real t1 = asin(sin(PI_4));
    writefln("Arcsine:    %.20f %.20f", t1, t1 * 180.0 / PI);

    immutable real t2 = acos(cos(PI_4));
    writefln("Arccosine:  %.20f %.20f", t2, t2 * 180.0 / PI);

    immutable real t3 = atan(tan(PI_4));
    writefln("Arctangent: %.20f %.20f", t3, t3 * 180.0 / PI);
}
