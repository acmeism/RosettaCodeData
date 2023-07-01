void main() @safe /*@nogc*/ {
    import std.stdio, std.algorithm, std.typecons, std.conv;

    static struct Bounty {
        int value;
        double weight, volume;
    }

    immutable Bounty panacea = {3000,  0.3, 0.025};
    immutable Bounty ichor =   {1800,  0.2, 0.015};
    immutable Bounty gold =    {2500,  2.0, 0.002};
    immutable Bounty sack =    {   0, 25.0, 0.25 };

    immutable maxPanacea = min(sack.weight / panacea.weight,
                               sack.volume / panacea.volume).to!int;
    immutable maxIchor   = min(sack.weight / ichor.weight,
                               sack.volume / ichor.volume).to!int;
    immutable maxGold    = min(sack.weight / gold.weight,
                               sack.volume / gold.volume).to!int;

    Bounty best = {0, 0, 0};
    Tuple!(int, int, int) bestAmounts;

    foreach (immutable nPanacea; 0 .. maxPanacea)
        foreach (immutable nIchor; 0 .. maxIchor)
            foreach (immutable nGold; 0 .. maxGold) {
                immutable Bounty current = {
                    value: nPanacea * panacea.value +
                           nIchor * ichor.value +
                           nGold * gold.value,
                    weight: nPanacea * panacea.weight +
                            nIchor * ichor.weight +
                            nGold * gold.weight,
                    volume: nPanacea * panacea.volume +
                            nIchor * ichor.volume +
                            nGold * gold.volume};

                if (current.value > best.value &&
                    current.weight <= sack.weight &&
                    current.volume <= sack.volume) {
                    best = Bounty(current.value, current.weight, current.volume);
                    bestAmounts = tuple(nPanacea, nIchor, nGold);
                }
            }

    writeln("Maximum value achievable is ", best.value);
    writefln("This is achieved by carrying (one solution) %d" ~
             " panacea, %d ichor and %d gold", bestAmounts[]);
    writefln("The weight to carry is %4.1f and the volume used is %5.3f",
             best.weight, best.volume);
}
