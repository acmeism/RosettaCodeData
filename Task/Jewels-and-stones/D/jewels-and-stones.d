import std.algorithm;
import std.stdio;

int countJewels(string s, string j) {
    int count;
    foreach (c; s) {
        if (j.canFind(c)) {
            count++;
        }
    }
    return count;
}

void main() {
    countJewels("aAAbbbb", "aA").writeln;
    countJewels("ZZ", "z").writeln;
}
