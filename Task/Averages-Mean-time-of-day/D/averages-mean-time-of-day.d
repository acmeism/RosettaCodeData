import std.stdio, std.range, std.algorithm, std.complex, std.math,
       std.format, std.conv;

double radians(in double d) pure nothrow @safe @nogc {
    return d * PI / 180;
}

double degrees(in double r) pure nothrow @safe @nogc {
    return r * 180 / PI;
}

double meanAngle(in double[] deg) pure nothrow @safe @nogc {
    return (deg.map!(d => fromPolar(1, d.radians)).sum / deg.length).arg.degrees;
}

string meanTime(in string[] times) pure @safe {
    auto t = times.map!(times => times.split(':').to!(int[3]));
    assert(t.all!(hms => 24.iota.canFind(hms[0]) &&
                         60.iota.canFind(hms[1]) &&
                         60.iota.canFind(hms[2])),
           "Invalid time");

    auto seconds = t.map!(hms => hms[2] + hms[1] * 60 + hms[0] * 3600);
    enum day = 24 * 60 * 60;
    const to_angles = seconds.map!(s => s * 360.0 / day).array;

    immutable mean_as_angle = to_angles.meanAngle;
    auto mean_seconds_fp = mean_as_angle * day / 360.0;
    if (mean_seconds_fp < 0)
        mean_seconds_fp += day;
    immutable mean_seconds = mean_seconds_fp.to!uint;
    immutable h = mean_seconds / 3600;
    immutable m = mean_seconds % 3600;
    return "%02d:%02d:%02d".format(h, m / 60, m % 60);
}

void main() @safe {
    ["23:00:17", "23:40:20", "00:12:45", "00:17:19"].meanTime.writeln;
}
