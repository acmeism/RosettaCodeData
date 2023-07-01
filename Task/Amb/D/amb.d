import std.stdio, std.array;

/** This amb function takes a comparison function and
the possibilities that need to be checked.*/
//string[] amb(in bool function(in string, in string) pure comp,
const(string)[] amb(in bool function(in string, in string) pure comp,
                    in string[][] options,
                    in string prev = null) pure {
    if (options.empty)
        return null;

    foreach (immutable opt; options.front) {
        // If this is the base call, prev is null and we need to
        // continue.
        if (!prev.empty && !comp(prev, opt))
            continue;

        // Take care of the case where we have no options left.
        if (options.length == 1)
            return [opt];

        // Traverse into the tree.
        const res = amb(comp, options[1 .. $], opt);

        // If it was a failure, try the next one.
        if (!res.empty)
            return opt ~ res; // We have a match!
    }

    return null; // No matches.
}

void main() {
    immutable sets = [["the", "that", "a"],
                      ["frog", "elephant", "thing"],
                      ["walked", "treaded", "grows"],
                      ["slowly", "quickly"]];

    // Pass in the comparator and the available sets.
    // (The comparator is not nothrow because of UTF.)
    const result = amb((s, t) => s.back == t.front, sets);

    if (result.empty)
        writeln("No matches found!");
    else
        writefln("%-(%s %)", result);
}
