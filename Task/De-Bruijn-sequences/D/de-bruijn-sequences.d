import std.array;
import std.conv;
import std.format;
import std.range;
import std.stdio;

immutable DIGITS = "0123456789";

string deBruijn(int k, int n) {
    auto alphabet = DIGITS[0..k];
    byte[] a;
    a.length = k * n;
    byte[] seq;

    void db(int t, int p) {
        if (t > n) {
            if (n % p == 0) {
                auto temp = a[1..p + 1];
                seq ~= temp;
            }
        } else {
            a[t] = a[t - p];
            db(t + 1, p);
            auto j = a[t - p] + 1;
            while (j < k) {
                a[t] = cast(byte)(j & 0xFF);
                db(t + 1, t);
                j++;
            }
        }
    }
    db(1, 1);
    string buf;
    foreach (i; seq) {
        buf ~= alphabet[i];
    }

    return buf ~ buf[0 .. n - 1];
}

bool allDigits(string s) {
    foreach (c; s) {
        if (c < '0' || '9' < c) {
            return false;
        }
    }
    return true;
}

void validate(string db) {
    auto le = db.length;
    int[10_000] found;
    string[] errs;
    // Check all strings of 4 consecutive digits within 'db'
    // to see if all 10,000 combinations occur without duplication.
    foreach (i; 0 .. le - 3) {
        auto s = db[i .. i + 4];
        if (allDigits(s)) {
            auto n = s.to!int;
            found[n]++;
        }
    }
    foreach (i; 0 .. 10_000) {
        if (found[i] == 0) {
            errs ~= format("    PIN number %04d missing", i);
        } else if (found[i] > 1) {
            errs ~= format("    PIN number %04d occurs %d times", i, found[i]);
        }
    }
    if (errs.empty) {
        writeln("  No errors found");
    } else {
        auto pl = (errs.length == 1) ? "" : "s";
        writeln("  ", errs.length, " error", pl, " found:");
        writefln("%-(%s\n%)", errs);
    }
}

void main() {
    auto db = deBruijn(10, 4);

    writeln("The length of the de Bruijn sequence is ", db.length);
    writeln("\nThe first 130 digits of the de Bruijn sequence are: ", db[0 .. 130]);
    writeln("\nThe last 130 digits of the de Bruijn sequence are: ", db[$ - 130 .. $]);

    writeln("\nValidating the deBruijn sequence:");
    validate(db);

    writeln("\nValidating the reversed deBruijn sequence:");
    validate(db.retro.to!string);

    auto by = db.dup;
    by[4443] = '.';
    db = by.idup;
    writeln("\nValidating the overlaid deBruijn sequence:");
    validate(db);
}
