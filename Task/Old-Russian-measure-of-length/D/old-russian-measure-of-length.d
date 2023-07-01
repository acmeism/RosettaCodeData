import std.stdio, std.string, std.algorithm, std.conv;

void main(in string[] args) {
    auto factor = ["arshin":         0.7112,
                   "centimeter":     0.01,
                   "diuym":          0.0254,
                   "fut":            0.3048,
                   "kilometer":  1_000.0,
                   "liniya":         0.00254,
                   "meter":          1.0,
                   "milia":      7_467.6,
                   "piad":           0.1778,
                   "sazhen":         2.1336,
                   "tochka":         0.000254,
                   "vershok":        0.04445,
                   "versta":     1_066.8];

    if (args.length != 3 || !isNumeric(args[1]) || args[2] !in factor)
        return writeln("Please provide args Value and Unit.");

    immutable magnitude = args[1].to!double;
    immutable meters = magnitude * factor[args[2]];
    writefln("%s %s to:\n", args[1], args[2]);
    foreach (immutable key; factor.keys.schwartzSort!(k => factor[k]))
       writefln("%10s: %s", key, meters / factor[key]);
}
