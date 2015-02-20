import std.stdio, std.algorithm, std.array;

enum F { abi, bea, cath, dee, eve, fay, gay, hope, ivy, jan }
enum M { abe, bob, col, dan, ed, fred, gav, hal, ian, jon }

alias PrefMapF = M[][F];
alias PrefMapM = F[][M];
alias Couples = M[F];

immutable PrefMapF womenPref;
immutable PrefMapM menPref;

static this() pure nothrow @safe {
    with (F) with (M) {
        womenPref = [
             abi:  [bob, fred, jon, gav, ian, abe, dan, ed, col, hal],
             bea:  [bob, abe, col, fred, gav, dan, ian, ed, jon, hal],
             cath: [fred, bob, ed, gav, hal, col, ian, abe, dan, jon],
             dee:  [fred, jon, col, abe, ian, hal, gav, dan, bob, ed],
             eve:  [jon, hal, fred, dan, abe, gav, col, ed, ian, bob],
             fay:  [bob, abe, ed, ian, jon, dan, fred, gav, col, hal],
             gay:  [jon, gav, hal, fred, bob, abe, col, ed, dan, ian],
             hope: [gav, jon, bob, abe, ian, dan, hal, ed, col, fred],
             ivy:  [ian, col, hal, gav, fred, bob, abe, ed, jon, dan],
             jan:  [ed, hal, gav, abe, bob, jon, col, ian, fred, dan]
        ];

        menPref = [
             abe:  [abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay],
             bob:  [cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay],
             col:  [hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan],
             dan:  [ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi],
             ed:   [jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay],
             fred: [bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay],
             gav:  [gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay],
             hal:  [abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee],
             ian:  [hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve],
             jon:  [abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope]
        ];
    }
}

/// Does 'first' appear before 'second' in preference list?
bool prefers(T)(in T[] preference, in T first, in T second)
pure nothrow @safe @nogc if (is(T == F) || is(T == M)) {
    //const found = preference.findAmong([first, second]);
    immutable T[2] two = [first, second];
    const found = preference.findAmong(two[]);
    return !(found.empty || found.front == second);
}

void checkStability(in Couples engaged, in PrefMapM menPref,
                    in PrefMapF womenPref) @safe {
    "Stablility:".writeln;
    bool stable = true;
    foreach (immutable bride, immutable groom; engaged) {
        const prefList = menPref[groom];

        foreach (immutable pr; prefList) {
            if (pr == bride) // He prefers his bride.
                break;

            if (prefers(prefList, pr, bride) &&
                // He prefers another woman.
                prefers(womenPref[pr], groom, engaged[pr])) {
                // Other woman prefers him.
                writeln("\t", pr, " prefers ", groom, " over ",
                        engaged[pr], " and ", groom, " prefers ",
                        pr, " over ", bride);
                stable = false;
            }
        }
    }

    if (stable)
        "\t(all marriages stable)".writeln;
}

void main() /*@safe*/ {
    auto bachelors = menPref.keys.sort().release;// No queue in Phobos.
    Couples engaged;

    "Matchmaking:".writeln;
    while (!bachelors.empty) {
        immutable suitor = bachelors[0];
        bachelors.popFront;
        immutable prefList = menPref[suitor];

        foreach (immutable bride; prefList) {
            if (bride !in engaged) { // She's available.
                writeln("\t", bride, " and ", suitor);
                engaged[bride] = suitor; // Hook up.
                break;
            }

            immutable groom = engaged[bride];
            if (prefers(womenPref[bride], suitor, groom)) {
                writeln("\t", bride, " dumped ", groom,
                        " for ", suitor);
                bachelors ~= groom; // Dump that zero.
                engaged[bride] = suitor; // Get a hero.
                break;
            }
        }
    }

    "Engagements:".writeln;
    foreach (immutable first, immutable second; engaged)
        writeln("\t", first, " and ", second);

    checkStability(engaged, menPref, womenPref);

    "Perturb:".writeln;
    engaged[F.abi].swap(engaged[F.bea]);
    writeln("\tengage abi with ", engaged[F.abi],
            " and bea with ", engaged[F.bea]);

    checkStability(engaged, menPref, womenPref);
}
