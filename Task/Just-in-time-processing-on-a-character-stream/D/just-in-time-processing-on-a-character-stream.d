import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.range;
import std.stdio;

struct UserInput {
    char formFeed;
    char lineFeed;
    char tab;
    char space;

    this(string ff, string lf, string tb, string sp) {
        formFeed = cast(char) ff.to!int;
        lineFeed = cast(char) lf.to!int;
        tab = cast(char) tb.to!int;
        space = cast(char) sp.to!int;
    }
}

auto getUserInput() {
    auto h = "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 "
           ~ "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28";
    auto ctor = (string[] a) => UserInput(a[0], a[1], a[2], a[3]);
    return h.split(' ').chunks(4).map!ctor.array;
}

void decode(string fileName, UserInput[] uiList) {
    auto text = readText(fileName);

    bool decode2(UserInput ui) {
        char f = 0;
        char l = 0;
        char t = 0;
        char s = 0;
        foreach (c; text) {
            if (f == ui.formFeed && l == ui.lineFeed && t == ui.tab && s == ui.space) {
                if (c == '!') return false;
                write(c);
                return true;
            }
            if (c == '\u000c') {
                f++; l=0; t=0; s=0;
            } else if (c == '\n') {
                l++; t=0; s=0;
            } else if (c == '\t') {
                t++; s=0;
            } else {
                s++;
            }
        }
        return false;
    }

    foreach (ui; uiList) {
        if (!decode2(ui)) break;
    }
    writeln;
}

void main() {
    auto uiList = getUserInput();
    decode("theRaven.txt", uiList);
}
