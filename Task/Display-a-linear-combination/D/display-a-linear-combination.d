import std.array;
import std.conv;
import std.format;
import std.math;
import std.stdio;

string linearCombo(int[] c) {
    auto sb = appender!string;
    foreach (i, n; c) {
        if (n==0) continue;
        string op;
        if (n < 0) {
            if (sb.data.empty) {
                op = "-";
            } else {
                op = " - ";
            }
        } else if (n > 0) {
            if (!sb.data.empty) {
                op = " + ";
            }
        }
        auto av = abs(n);
        string coeff;
        if (av != 1) {
            coeff = to!string(av) ~ "*";
        }
        sb.formattedWrite("%s%se(%d)", op, coeff, i+1);
    }
    if (sb.data.empty) {
        return "0";
    }
    return sb.data;
}

void main() {
    auto combos = [
        [1, 2, 3],
        [0, 1, 2, 3],
        [1, 0, 3, 4],
        [1, 2, 0],
        [0, 0, 0],
        [0],
        [1, 1, 1],
        [-1, -1, -1],
        [-1, -2, 0, -3],
        [-1],
    ];
    foreach (c; combos) {
        auto arr = c.format!"%s";
        writefln("%-15s  ->  %s", arr, linearCombo(c));
    }
}
