import std.stdio, std.array, std.file, std.regex, std.string,
       std.range;

void main() {
    string[][] rules = readText("markov_rules.txt").splitLines()
                       .split("");
    auto tests = readText("markov_tests.txt").splitLines();
    auto re = ctRegex!(r"^([^#]*?)\s+->\s+(\.?)(.*)"); // 130 MB RAM.

    auto pairs = zip(StoppingPolicy.requireSameLength, tests, rules);
    foreach (test, rule; pairs) {
        auto origTest = test.dup;

        string[][] capt;
        foreach (line; rule) {
            auto m = line.match(re);
            if (!m.empty)
                capt ~= m.captures.array()[1 .. $];
        }

    REDO:
        auto copy = test;
        foreach (c; capt) {
            test = test.replace(c[0], c[2]);
            if (c[1] == ".")
                break;
            if (test != copy)
                goto REDO;
        }
        writefln("%s\n%s\n", origTest, test);
    }
}
