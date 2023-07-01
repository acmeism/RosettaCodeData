import std.conv;
import std.stdio;

string commatize(ulong n) {
    auto s = n.to!string;
    auto le = s.length;
    for (int i = le - 3; i >= 1; i -= 3) {
        s = s[0..i]
          ~ ","
          ~ s[i..$];
    }
    return s;
}

void main() {
    ulong[] starts = [cast(ulong)1e2, cast(ulong)1e6, cast(ulong)1e7, cast(ulong)1e9, 7123];
    int[] counts = [30, 15, 15, 10, 25];
    for (int i = 0; i < starts.length; i++) {
        int count = 0;
        auto j = starts[i];
        ulong pow = 100;
        while (true) {
            if (j < pow * 10) {
                break;
            }
            pow *= 10;
        }
        writefln("First %d gapful numbers starting at %s:", counts[i], commatize(starts[i]));
        while (count < counts[i]) {
            auto fl = (j / pow) * 10 + (j % 10);
            if (j % fl == 0) {
                write(j, ' ');
                count++;
            }
            j++;
            if (j >= 10 * pow) {
                pow *= 10;
            }
        }
        writeln("\n");
    }
}
