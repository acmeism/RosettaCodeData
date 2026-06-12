import std.stdio, std.algorithm, std.exception, std.array;

immutable struct DecisionTable {
    alias immutable(bool)[] IBA;
    const string[] conds,  actions;
    immutable IBA[IBA] rules;

    private static immutable(bool[]) growTo(in bool[] b,
                                            in size_t newLen)
    pure nothrow {
        auto result = new bool[newLen];
        result[0 .. b.length] = b[];
        return result.assumeUnique;
    }

    this(immutable string[] c,
         immutable string[] a,
         immutable bool[][][] q) pure nothrow {
        conds = c;
        actions = a;
        IBA[IBA] r;
        foreach (p; q)
            r[growTo(p[0], conds.length)] =
                growTo(p[1], actions.length);
        rules = r.assumeUnique;
    }

    string[] test(in bool[] tested,
                  in string NoMatchMsg="It is fine :)")
    const pure nothrow {
        string[] rightActions;
        auto iTested = growTo(tested, conds.length);
        if (iTested in rules)
            foreach (immutable i, immutable e; rules[iTested])
                if (e)
                    rightActions ~= actions[i];

        if (!rightActions.empty)
            return rightActions;
        return [NoMatchMsg];
    }

    void consult() const {
        bool[] query;

        foreach (cond; conds) {
            write(cond, "? [y=yes/others=no] ");
            string answer = "no";
            try
                answer = stdin.readln;
            catch (StdioException)
                writeln("no");
            query ~= !!answer.startsWith('y', 'Y');
        }

        writefln("%-(%2s\n%)", test(query));
    }
}

void main() {
    enum { F = false, T = true }
    immutable d = immutable(DecisionTable)(
            ["Printer is unrecognised",
             "A red light is flashing",
             "Printer does not print"],

            ["Check the power cable",
             "Check the printer-computer cable",
             "Ensure printer software is installed",
             "Check/replace ink",
             "Check for paper jam"],

             [[[T, F, F], [F, F, T]],
              [[F, T, F], [F, F, F, T]],
              [[T, T, F], [F, F, T, T]],
              [[F, F, T], [F, F, F, F, T]],
              [[T, F, T], [T, T, T]],
              [[F, T, T], [F, F, F, T, T]],
              [[T, T, T], [F, T, T, T, F]]
             ]
        );

    d.consult;
}
