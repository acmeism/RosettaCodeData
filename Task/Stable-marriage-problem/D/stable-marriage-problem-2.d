import std.stdio, std.algorithm, std.array;

enum F { abi, bea, cath, dee, eve, fay, gay, hope, ivy, jan }
enum M { abe, bob, col, dan, ed, fred, gav, hal, ian, jon }

alias M[][F] PrefMapF;
alias F[][M] PrefMapM;
alias M[F] Couples;

immutable PrefMapF womenPref;
immutable PrefMapM menPref;

pure nothrow static this() {
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
bool prefers(T)(in T[] prefer, in T first, in T second)
pure nothrow if (is(T == F) || is(T == M)) {
    foreach (p; prefer) {
        if (p == first) return true;
        if (p == second) return false;
    }
    return false; // no preference
}

void checkStability(in Couples engaged, in PrefMapM menPref,
                    in PrefMapF womenPref) {
    writeln("Stablility:");
    bool stable = true;
    foreach (bride, groom; engaged) {
        const prefList = menPref[groom];

        foreach (pr; prefList) {
            if (pr == bride) // he prefers his bride
                break;

            if (prefers(prefList, pr, bride) &&
                // he prefers another woman
                prefers(womenPref[pr], groom, engaged[pr])) {
                // other woman prefers him
                writeln("\t", pr, " prefers ", groom, " over ",
                        engaged[pr], " and ", groom, " prefers ",
                        pr, " over ", bride);
                stable = false;
            }
        }
    }

    if (stable)
        writeln("\t(all marriages stable)");
}

void main() {
    M[] bachelors = menPref.keys.sort().release();// No queue in Phobos
    Couples engaged;

    writeln("Matchmaking:");
    while (!bachelors.empty) {
        immutable suitor = bachelors[0];
        bachelors.popFront();
        immutable prefList = menPref[suitor];

        foreach (bride; prefList) {
            if (bride !in engaged) { // she's available
                writeln("\t", bride, " and ", suitor);
                engaged[bride] = suitor; // hook up
                break;
            }

            immutable groom = engaged[bride];
            if (prefers(womenPref[bride], suitor, groom)) {
                writeln("\t", bride, " dumped ", groom,
                        " for ", suitor);
                bachelors ~= groom; // dump that zero
                engaged[bride] = suitor; // get a hero
                break;
            }
        }
    }

    writeln("Engagements:");
    foreach (first, second; engaged)
        writeln("\t", first, " and ", second);

    checkStability(engaged, menPref, womenPref);

    writeln("Perturb:");
    swap(engaged[F.abi], engaged[F.bea]);
    writeln("\tengage abi with ", engaged[F.abi],
            " and bea with ", engaged[F.bea]);

    checkStability(engaged, menPref, womenPref);
}
