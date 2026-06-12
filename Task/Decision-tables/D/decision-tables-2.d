import std.stdio, std.string;

struct DataPair(size_t N) {
    string message;
    immutable char[N] truth;
}

immutable DataPair!8[] conditions = [
    {"Printer does not print",               "####...."},
    {"A red light is flashing",              "##..##.."},
    {"Printer is unrecognised",              "#.#.#.#."}];

immutable DataPair!8[] solutions = [
    {"Check the power cable",                "..#....."},
    {"Check the printer-computer cable",     "#.#....."},
    {"Ensure printer software is installed", "#.#.#.#."},
    {"Check/replace ink",                    "##..##.."},
    {"Check for paper jam",                  ".#.#...."}];

void main() {
    size_t code = 0;

    foreach (immutable cond; conditions) {
        write(cond.message, "? [y=yes/others=no] ");
        string answer = "no";
        try
            answer = stdin.readln();
        catch (StdioException)
            writeln("no");
        code = (code << 1) | !answer.startsWith('y', 'Y');
    }

    if (code == (2 ^^ conditions.length) - 1)
        writeln("\nSo, you don't have a problem then?");
    else {
        writeln("\nSolutions:");
        foreach (immutable sol; solutions)
            if (sol.truth[code] == '#')
                writeln("    ", sol.message);
    }
}
