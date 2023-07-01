import std.algorithm.iteration;
import std.algorithm.mutation;
import std.algorithm.searching;
import std.algorithm.sorting;
import std.array;
import std.stdio;
import std.string;

immutable STX = 0x02;
immutable ETX = 0x03;

string bwt(string s) {
    if (s.any!"a==0x02 || a==0x03") {
        throw new Exception("Input can't contain STX or ETX");
    }
    char[] ss = (STX ~ s ~ ETX).dup;
    string[] table;
    foreach (i; 0..ss.length) {
        table ~= ss.idup;
        bringToFront(ss[0..$-1], ss[$-1..$]);
    }
    table.sort();
    return table.map!"a[$-1]".array;
}

string ibwt(string r) {
    const len = r.length;
    string[] table;
    table.length = len;
    foreach (_; 0..len) {
        foreach (i; 0..len) {
            table[i] = r[i] ~ table[i];
        }
        table.sort();
    }
    foreach (row; table) {
        if (row[$-1] == ETX) {
            return row[1..len-1];
        }
    }
    return "";
}

string makePrintable(string s) {
    return tr(s, "\u0002\u0003", "^|");
}

void main() {
    immutable tests = [
        "banana",
        "appellee",
        "dogwood",
        "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
        "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
        "\u0002ABC\u0003"
    ];

    foreach (test; tests) {
        writeln(test.makePrintable);
        write(" --> ");

        string t;
        try {
            t = bwt(test);
            writeln(t.makePrintable);
        } catch (Exception e) {
            writeln("ERROR: ", e.message);
        }

        auto r = ibwt(t);
        writeln(" --> ", r);
        writeln;
    }
}
