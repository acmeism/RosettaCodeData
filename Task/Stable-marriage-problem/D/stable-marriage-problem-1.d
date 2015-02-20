import std.stdio, std.array, std.algorithm, std.string;


string[string] matchmaker(string[][string] guyPrefers,
                          string[][string] girlPrefers) /*@safe*/ {
    string[string] engagedTo;
    string[] freeGuys = guyPrefers.keys;

    while (freeGuys.length) {
        const string thisGuy = freeGuys[0];
        freeGuys.popFront();
        const auto thisGuyPrefers = guyPrefers[thisGuy];
        foreach (girl; thisGuyPrefers) {
            if (girl !in engagedTo) { // girl is free
                engagedTo[girl] = thisGuy;
                break;
            } else {
                string otherGuy = engagedTo[girl];
                string[] thisGirlPrefers = girlPrefers[girl];
                if (thisGirlPrefers.countUntil(thisGuy) <
                    thisGirlPrefers.countUntil(otherGuy)) {
                    // this girl prefers this guy to
                    // the guy she's engagedTo to.
                    engagedTo[girl] = thisGuy;
                    freeGuys ~= otherGuy;
                    break;
                }
                // else no change, keep looking for this guy
            }
        }
    }

    return engagedTo;
}


bool check(bool doPrint=false)(string[string] engagedTo,
                               string[][string] guyPrefers,
                               string[][string] galPrefers) @safe {
    enum MSG = "%s likes %s better than %s and %s " ~
               "likes %s better than their current partner";
    string[string] inverseEngaged;
    foreach (k, v; engagedTo)
        inverseEngaged[v] = k;

    foreach (she, he; engagedTo) {
        auto sheLikes = galPrefers[she];
        auto sheLikesBetter = sheLikes[0 .. sheLikes.countUntil(he)];
        auto heLikes = guyPrefers[he];
        auto heLikesBetter = heLikes[0 .. heLikes.countUntil(she)];
        foreach (guy; sheLikesBetter) {
            auto guysGirl = inverseEngaged[guy];
            auto guyLikes = guyPrefers[guy];

            if (guyLikes.countUntil(guysGirl) >
                guyLikes.countUntil(she)) {
                static if (doPrint)
                    writefln(MSG, she, guy, he, guy, she);
                return false;
            }
        }

        foreach (gal; heLikesBetter) {
            auto girlsGuy = engagedTo[gal];
            auto galLikes = galPrefers[gal];

            if (galLikes.countUntil(girlsGuy) >
                galLikes.countUntil(he)) {
                static if (doPrint)
                    writefln(MSG, he, gal, she, gal, he);
                return false;
            }
        }
    }

    return true;
}


void main() /*@safe*/ {
    auto guyData = "abe  abi eve cath ivy jan dee fay bea hope gay
                    bob  cath hope abi dee eve fay bea jan ivy gay
                    col  hope eve abi dee bea fay ivy gay cath jan
                    dan  ivy fay dee gay hope eve jan bea cath abi
                    ed   jan dee bea cath fay eve abi ivy hope gay
                    fred bea abi dee gay eve ivy cath jan hope fay
                    gav  gay eve ivy bea cath abi dee hope jan fay
                    hal  abi eve hope fay ivy cath jan bea gay dee
                    ian  hope cath dee gay bea abi fay ivy jan eve
                    jon  abi fay jan gay eve bea dee cath ivy hope";

    auto galData = "abi  bob fred jon gav ian abe dan ed col hal
                    bea  bob abe col fred gav dan ian ed jon hal
                    cath fred bob ed gav hal col ian abe dan jon
                    dee  fred jon col abe ian hal gav dan bob ed
                    eve  jon hal fred dan abe gav col ed ian bob
                    fay  bob abe ed ian jon dan fred gav col hal
                    gay  jon gav hal fred bob abe col ed dan ian
                    hope gav jon bob abe ian dan hal ed col fred
                    ivy  ian col hal gav fred bob abe ed jon dan
                    jan  ed hal gav abe bob jon col ian fred dan";

    string[][string] guyPrefers, galPrefers;
    foreach (line; guyData.splitLines())
        guyPrefers[split(line)[0]] = split(line)[1..$];
    foreach (line; galData.splitLines())
        galPrefers[split(line)[0]] = split(line)[1..$];

    writeln("Engagements:");
    auto engagedTo = matchmaker(guyPrefers, galPrefers);

    writeln("\nCouples:");
    string[] parts;
    foreach (k; engagedTo.keys.sort())
        writefln("%s is engagedTo to %s", k, engagedTo[k]);
    writeln();

    bool c = check!(true)(engagedTo, guyPrefers, galPrefers);
    writeln("Marriages are ", c ? "stable" : "unstable");

    writeln("\n\nSwapping two fiances to introduce an error");
    auto gals = galPrefers.keys.sort();
    swap(engagedTo[gals[0]], engagedTo[gals[1]]);
    foreach (gal; gals[0 .. 2])
        writefln("  %s is now engagedTo to %s", gal, engagedTo[gal]);
    writeln();

    c = check!(true)(engagedTo, guyPrefers, galPrefers);
    writeln("Marriages are ", c ? "stable" : "unstable");
}
