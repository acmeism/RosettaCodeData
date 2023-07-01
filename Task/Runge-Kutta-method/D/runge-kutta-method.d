import std.stdio, std.math, std.typecons;

alias FP = real;
alias FPs = Typedef!(FP[101]);

void runge(in FP function(in FP, in FP)
           pure nothrow @safe @nogc yp_func,
           ref FPs t, ref FPs y, in FP dt) pure nothrow @safe @nogc {
    foreach (immutable n; 0 .. t.length - 1) {
        immutable FP
            dy1 = dt * yp_func(t[n], y[n]),
            dy2 = dt * yp_func(t[n] + dt / 2.0, y[n] + dy1 / 2.0),
            dy3 = dt * yp_func(t[n] + dt / 2.0, y[n] + dy2 / 2.0),
            dy4 = dt * yp_func(t[n] + dt, y[n] + dy3);
        t[n + 1] = t[n] + dt;
        y[n + 1] = y[n] + (dy1 + 2.0 * (dy2 + dy3) + dy4) / 6.0;
    }
}

FP calc_err(in FP t, in FP calc) pure nothrow @safe @nogc {
    immutable FP actual = (t ^^ 2 + 4.0) ^^ 2 / 16.0;
    return abs(actual - calc);
}

void main() {
    enum FP dt = 0.10;
    FPs t_arr, y_arr;

    t_arr[0] = 0.0;
    y_arr[0] = 1.0;
    runge((t, y) => t * y.sqrt, t_arr, y_arr, dt);

    foreach (immutable i; 0 .. t_arr.length)
        if (i % 10 == 0)
            writefln("y(%.1f) = %.8f Error: %.6g",
                     t_arr[i], y_arr[i],
                     calc_err(t_arr[i], y_arr[i]));
}
