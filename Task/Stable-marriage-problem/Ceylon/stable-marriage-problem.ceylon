abstract class Single(name) of Gal | Guy {

    shared String name;
    shared late Single[] preferences;

    shared variable Single? fiance = null;
    shared Boolean free => fiance is Null;

    shared variable Integer currentProposalIndex = 0;

    "Does this single prefer this other single over their fiance?"
    shared Boolean prefers(Single otherSingle) =>
            let (p1 = preferences.firstIndexWhere(otherSingle.equals), f = fiance)
            if (!exists p1)
            then false
            else if (!exists f)
            then true
            else if (exists p2 = preferences.firstIndexWhere(f.equals))
            then p1 < p2
            else false;

    string => name;
}

abstract class Guy(String name) of abe | bob | col | dan | ed | fred | gav | hal | ian | jon extends Single(name) {}

object abe extends Guy("Abe") {}
object bob extends Guy("Bob") {}
object col extends Guy("Col") {}
object dan extends Guy("Dan") {}
object ed extends Guy("Ed") {}
object fred extends Guy("Fred") {}
object gav extends Guy("Gav") {}
object hal extends Guy("Hal") {}
object ian extends Guy("Ian") {}
object jon extends Guy("Jon") {}

abstract class Gal(String name) of abi | bea | cath | dee | eve | fay | gay | hope | ivy | jan extends Single(name) {}

object abi extends Gal("Abi") {}
object bea extends Gal("Bea") {}
object cath extends Gal("Cath") {}
object dee extends Gal("Dee") {}
object eve extends Gal("Eve") {}
object fay extends Gal("Fay") {}
object gay extends Gal("Gay") {}
object hope extends Gal("Hope") {}
object ivy extends Gal("Ivy") {}
object jan extends Gal("Jan") {}

Guy[] guys = `Guy`.caseValues;
Gal[] gals = `Gal`.caseValues;

"The main function. Run this one."
shared void run() {

    abe.preferences = [ abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay ];
    bob.preferences = [ cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay ];
    col.preferences = [ hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan ];
    dan.preferences = [ ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi ];
    ed.preferences = [ jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay ];
    fred.preferences = [ bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay ];
    gav.preferences = [ gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay ];
    hal.preferences = [ abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee ];
    ian.preferences = [ hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve ];
    jon.preferences = [ abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope ];

    abi.preferences = [ bob, fred, jon, gav, ian, abe, dan, ed, col, hal ];
    bea.preferences = [ bob, abe, col, fred, gav, dan, ian, ed, jon, hal ];
    cath.preferences = [ fred, bob, ed, gav, hal, col, ian, abe, dan, jon ];
    dee.preferences = [ fred, jon, col, abe, ian, hal, gav, dan, bob, ed ];
    eve.preferences = [ jon, hal, fred, dan, abe, gav, col, ed, ian, bob ];
    fay.preferences = [ bob, abe, ed, ian, jon, dan, fred, gav, col, hal ];
    gay.preferences = [ jon, gav, hal, fred, bob, abe, col, ed, dan, ian ];
    hope.preferences = [ gav, jon, bob, abe, ian, dan, hal, ed, col, fred ];
    ivy.preferences = [ ian, col, hal, gav, fred, bob, abe, ed, jon, dan ];
    jan.preferences = [ ed, hal, gav, abe, bob, jon, col, ian, fred, dan ];

    print("------ the matchmaking process ------");
    matchmake();
    print("------ the final engagements ------");
    for (guy in guys) {
        print("``guy`` is engaged to ``guy.fiance else "no one"``");
    }
    print("------ is it stable? ------");
    checkStability();
    value temp = jon.fiance;
    jon.fiance = fred.fiance;
    fred.fiance = temp;
    print("------ is it stable after switching jon and fred's partners? ------");
    checkStability();
}

"Match up all the singles with the Gale/Shapley algorithm."
void matchmake() {
    while (true) {
        value singleGuys = guys.filter(Guy.free);
        if (singleGuys.empty) {
            return;
        }
        for (guy in singleGuys) {
            if (exists gal = guy.preferences[guy.currentProposalIndex]) {
                guy.currentProposalIndex++;
                value fiance = gal.fiance;
                if (!exists fiance) {
                    print("``guy`` and ``gal`` just got engaged!");
                    guy.fiance = gal;
                    gal.fiance = guy;
                }
                else {
                    if (gal.prefers(guy)) {
                        print("``gal`` dumped ``fiance`` for ``guy``!");
                        fiance.fiance = null;
                        gal.fiance = guy;
                        guy.fiance = gal;
                    }
                    else {
                        print("``gal`` turned down ``guy`` and stayed with ``fiance``!");
                    }
                }
            }
        }
    }
}

void checkStability() {
    variable value stabilityFlag = true;
    for (gal in gals) {
        for (guy in guys) {
            if (guy.prefers(gal) && gal.prefers(guy)) {
                stabilityFlag = false;
                print("``guy`` prefers ``gal`` over ``guy.fiance else "nobody"``
                       and ``gal`` prefers ``guy`` over ``gal.fiance else "nobody"``!".normalized);
            }
        }
    }
    print("``if(!stabilityFlag) then "Not " else ""``Stable!");
}
