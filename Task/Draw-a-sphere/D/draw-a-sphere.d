import std.stdio, std.math, std.algorithm, std.numeric;

alias V3 = double[3];
immutable light = normalize([30.0, 30.0, -50.0]);

V3 normalize(V3 v) pure @nogc {
    v[] /= dotProduct(v, v) ^^ 0.5;
    return v;
}

double dot(in ref V3 x, in ref V3 y) pure nothrow @nogc {
    immutable double d = dotProduct(x, y);
    return d < 0 ? -d : 0;
}

void drawSphere(in double R, in double k, in double ambient) @nogc {
    enum shades = ".:!*oe&#%@";
    foreach (immutable i; cast(int)floor(-R) .. cast(int)ceil(R) + 1) {
        immutable double x = i + 0.5;
        foreach (immutable j; cast(int)floor(-2 * R) ..
                              cast(int)ceil(2 * R) + 1) {
            immutable double y = j / 2. + 0.5;
            if (x ^^ 2 + y ^^ 2 <= R ^^ 2) {
                immutable vec = [x, y, (R^^2 - x^^2 - y^^2) ^^ 0.5]
                                .normalize;
                immutable double b = dot(light, vec) ^^ k + ambient;
                int intensity = cast(int)((1 - b) * (shades.length-1));
                intensity = min(shades.length - 1, max(intensity, 0));
                shades[intensity].putchar;
            } else
                ' '.putchar;
        }
        '\n'.putchar;
    }
}

void main() {
    drawSphere(20, 4, 0.1);
    drawSphere(10, 2, 0.4);
}
