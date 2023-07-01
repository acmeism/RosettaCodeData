import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.uni;

void printVerse(string name) {
    auto sb = name.map!toLower.array;
    sb[0] = sb[0].toUpper;

    string x = sb.to!string;
    string y;
    switch(sb[0]) {
        case 'A':
        case 'E':
        case 'I':
        case 'O':
        case 'U':
            y = x.map!toLower.to!string;
            break;
        default:
            y = x[1..$];
            break;
    }
    string b = "b" ~ y;
    string f = "f" ~ y;
    string m = "m" ~ y;
    switch (x[0]) {
        case 'B':
            b = y;
            break;
        case 'F':
            f = y;
            break;
        case 'M':
            m = y;
            break;
        default:
            // no adjustment needed
            break;
    }

    writeln(x, ", ", x, ", bo-", b);
    writeln("Banana-fana fo-", f);
    writeln("Fee-fi-mo-", m);
    writeln(x, "!\n");
}

void main() {
    foreach (name; ["Gary","Earl","Billy","Felix","Mary","steve"]) {
        printVerse(name);
    }
}
