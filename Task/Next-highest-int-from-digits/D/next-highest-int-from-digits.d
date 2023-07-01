import std.algorithm;
import std.array;
import std.conv;
import std.stdio;

string next(string s) {
    auto sb = appender!string;
    auto index = s.length - 1;

    //  Scan right-to-left through the digits of the number until you find a digit with a larger digit somewhere to the right of it.
    while (index > 0 && s[index - 1] >= s[index]) {
        index--;
    }
    //  Reached beginning.  No next number.
    if (index == 0) {
        return "0";
    }

    //  Find digit on the right that is both more than it, and closest to it.
    auto index2 = index;
    foreach (i; index + 1 .. s.length) {
        if (s[i] < s[index2] && s[i] > s[index - 1]) {
            index2 = i;
        }
    }

    //  Found data, now build string
    //  Beginning of String
    if (index > 1) {
        sb ~= s[0 .. index - 1];
    }

    //  Append found, place next
    sb ~= s[index2];

    //  Get remaining characters
    auto chars = [cast(dchar) s[index - 1]];
    foreach (i; index .. s.length) {
        if (i != index2) {
            chars ~= s[i];
        }
    }

    //  Order the digits to the right of this position, after the swap; lowest-to-highest, left-to-right.
    chars.sort;
    sb ~= chars;

    return sb.data;
}

long factorial(long n) {
    long fact = 1;
    foreach (num; 2 .. n + 1) {
        fact *= num;
    }
    return fact;
}

void testAll(string s) {
    writeln("Test all permutations of: ", s);
    string sOrig = s;
    string sPrev = s;
    int count = 1;

    //  Check permutation order.  Each is greater than the last
    bool orderOk = true;
    int[string] uniqueMap = [s: 1];
    while (true) {
        s = next(s);
        if (s == "0") {
            break;
        }

        count++;
        if (s.to!long < sPrev.to!long) {
            orderOk = false;
        }
        uniqueMap.update(s, {
            return 1;
        }, (int a) {
            return a + 1;
        });
        sPrev = s;
    }
    writeln("    Order:  OK =  ", orderOk);

    //  Test last permutation
    auto reverse = sOrig.dup.to!(dchar[]).reverse.to!string;
    writefln("    Last permutation:  Actual = %s, Expected = %s, OK = %s", sPrev, reverse, sPrev == reverse);

    //  Check permutations unique
    bool unique = true;
    foreach (k, v; uniqueMap) {
        if (v > 1) {
            unique = false;
            break;
        }
    }
    writeln("    Permutations unique:  OK =  ", unique);

    //  Check expected count.
    int[char] charMap;
    foreach (c; sOrig) {
        charMap.update(c, {
            return 1;
        }, (int v) {
            return v + 1;
        });
    }
    long permCount = factorial(sOrig.length);
    foreach (k, v; charMap) {
        permCount /= factorial(v);
    }
    writefln("    Permutation count:  Actual = %d, Expected = %d, OK = %s", count, permCount, count == permCount);
}

void main() {
    foreach (s; ["0", "9", "12", "21", "12453", "738440", "45072010", "95322020", "9589776899767587796600", "3345333"]) {
        writeln(s, " -> ", next(s));
    }

    testAll("12345");
    testAll("11122");
}
