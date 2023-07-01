import std.stdio, std.typecons, std.algorithm, std.string, std.array;

void turing(Sy, St)(in St state, Sy[int] tape, in int pos,
                    in Tuple!(Sy, int, St)[Sy][St] rules) {
    if (state.empty) return;
    const r = rules[state][tape[pos] = tape.get(pos, Sy.init)];
    writefln("%-(%s%)", tape.keys.sort()
        .map!(i => format(i == pos ? "(%s)" : " %s ", tape[i])));
    tape[pos] = r[0];
    turing(r[2], tape, pos + r[1], rules);
}

void main() {
    turing("a", null, 0,
           ["a": [0: tuple(1,  1, "b"), 1: tuple(1, -1, "c")],
            "b": [0: tuple(1, -1, "a"), 1: tuple(1,  1, "b")],
            "c": [0: tuple(1, -1, "b"), 1: tuple(1,  0, "")]]);
}
