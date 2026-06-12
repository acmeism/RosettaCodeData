void main() {
    import std.stdio, std.algorithm, std.typecons, combinations3;

    alias P = tuple;
    immutable items = [
P("alliance",  -624),  P("archbishop",  -915),  P("balm",        397),
P("bonnet",     452),  P("brute",        870),  P("centipede",  -658),
P("cobol",      362),  P("covariate",    590),  P("departure",   952),
P("deploy",      44),  P("diophantine",  645),  P("efferent",     54),
P("elysee",    -326),  P("eradicate",    376),  P("escritoire",  856),
P("exorcism",  -983),  P("fiat",         170),  P("filmy",      -874),
P("flatworm",   503),  P("gestapo",      915),  P("infra",      -847),
P("isis",      -982),  P("lindholm",     999),  P("markham",     475),
P("mincemeat", -880),  P("moresby",      756),  P("mycenae",     183),
P("plugging",  -266),  P("smokescreen",  423),  P("speakeasy",  -745),
P("vein",       813)];

    foreach (immutable n; 1 .. items.length)
        foreach (const comb; items.combinations(n))
            if (comb.map!q{ a[1] }.sum == 0)
                return writefln("A subset of length %d: %-(%s, %)", n,
                                comb.map!q{ a[0] });
    "No solution found.".writeln;
}
