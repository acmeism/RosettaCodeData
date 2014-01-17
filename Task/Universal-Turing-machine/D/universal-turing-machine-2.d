import std.stdio, std.typecons, std.array, std.algorithm, std.string;

void turing(Sy, St)(in Sy[] symbols, in Sy blank, in St initialState,
                    in St[] haltStates, in St[] runningStates,
                    in Tuple!(Sy, string, St)[Sy][St] rules,
                    in Sy[] startingTape = []) {
    Sy[int] tape;
    foreach (i, sy; startingTape)
        tape[i] = sy;
    int pos = 0;
    St state = initialState;

    while (!haltStates.canFind(state)) {
        //auto symbol = tape.setDefault(pos, blank);
        if (pos !in tape)
            tape[pos] = blank;
        auto symbol = tape[pos];
        tape.keys.sort()
        .map!(i => format(["%s", "(%s)"][i == pos], tape[i]))
        .join(" ").writeln;
        //{const outsym, const action, state} = rules[state][symbol];
        const r = rules[state][symbol];
        state = r[2];
        tape[pos] = r[0];
        pos += ["left": -1, "stay": 0, "right": 1][r[1]];
    }
}

void main() {
    alias t = tuple;

    turing(['b', '1'],       // Permitted symbols.
           'b',              // Blank symbol.
           "q0",             // Starting state.
           ["qf"],           // Terminating states.
           ["q0"],           // Running states.
                             // Operating rules.
           ["q0": ['1': t('1', "right", "q0"),
                   'b': t('1', "stay", "qf")]],
           ['1', '1', '1']); // Starting tape.
    writeln;

    turing([0, 1],           // Permitted symbols.
           0,                // Blank symbol.
           "a",              // Starting state.
           ["halt"],         // Terminating states.
           ["a", "b", "c"],  // Running states.
                             // Operating rules.
           ["a": [0: t(1, "right", "b"), 1: t(1, "left",  "c")],
            "b": [0: t(1, "left",  "a"), 1: t(1, "right", "b")],
            "c": [0: t(1, "left",  "b"), 1: t(1, "stay",  "halt")]]);
}
