import std.stdio;

float kahanSum(float[] fa...) {
    float sum = 0.0;
    float c = 0.0;
    foreach (f; fa) {
        float y = f - c;
        float t = sum + y;
        c = (t - sum) - y;
        sum = t;
    }
    return sum;
}

void main() {
    float a = 1.0;
    float b = float.epsilon;
    float c = -b;
    writefln("Epsilon      = %0.8e", b);
    writefln("(a + b) + c  = %0.8f", ((a + b) + c));
    writefln("Kahan sum    = %0.8f", kahanSum(a, b, c));
}
