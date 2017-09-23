import std.stdio, std.string, std.algorithm, std.array, std.conv,
    std.ascii, std.range;

string[] naturalSort(string[] arr) /*pure @safe*/ {
    static struct Part {
        string s;

        int opCmp(in ref Part other) const pure {
            return (s[0].isDigit && other.s[0].isDigit) ?
                cmp([s.to!ulong], [other.s.to!ulong]) :
                cmp(s, other.s);
        }
    }

    static mapper(in string txt) /*pure nothrow @safe*/ {
        auto r = txt
                 .strip
                 .tr(whitespace, " ", "s")
                 .toLower
                 .chunkBy!isDigit
                 .map!(p => Part(p.text))
                 .array;
        return (r.length > 1 && r[0].s == "the") ? r.dropOne : r;
    }

    return arr.schwartzSort!mapper.release;
}

void main() /*@safe*/ {
    const tests = [
        // Ignoring leading spaces.
        ["ignore leading spaces: 2-2", " ignore leading spaces: 2-1", "
     ignore leading spaces: 2+1", "  ignore leading spaces: 2+0"],

        // Ignoring multiple adjacent spaces (m.a.s).
        ["ignore m.a.s spaces: 2-2", "ignore m.a.s  spaces: 2-1",
         "ignore m.a.s   spaces: 2+0", "ignore m.a.s    spaces: 2+1"],

        // Equivalent whitespace characters.
        ["Equiv. spaces: 3-3", "Equiv.\rspaces: 3-2",
         "Equiv.\x0cspaces: 3-1", "Equiv.\x0bspaces: 3+0",
         "Equiv.\nspaces: 3+1", "Equiv.\tspaces: 3+2"],

        // Case Indepenent [sic] sort.
        ["cASE INDEPENENT: 3-2" /* [sic] */, "caSE INDEPENENT: 3-1" /* [sic] */,
         "casE INDEPENENT: 3+0" /* [sic] */, "case INDEPENENT: 3+1" /* [sic] */],

        // Numeric fields as numerics.
        ["foo100bar99baz0.txt", "foo100bar10baz0.txt",
         "foo1000bar99baz10.txt", "foo1000bar99baz9.txt"],

        // Title sorts.
        ["The Wind in the Willows", "The 40th step more",
         "The 39 steps", "Wanda"]];

    void printTexts(Range)(string tag, Range range) {
        const sic = range.front.canFind("INDEPENENT") ? " [sic]" : "";
        writefln("\n%s%s:\n%-(  |%s|%|\n%)", tag, sic, range);
    }

    foreach (test; tests) {
        printTexts("Test strings", test);
        printTexts("Normally sorted", test.dup.sort());
        printTexts("Naturally sorted", test.dup.naturalSort());
    }
}
