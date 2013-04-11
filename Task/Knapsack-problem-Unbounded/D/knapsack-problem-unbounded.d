import std.stdio, std.algorithm, std.typecons;

struct Bounty {
    int value;
    double weight, volume;
}

void main() {
    immutable Bounty panacea = {3000,  0.3, 0.025};
    immutable Bounty ichor =   {1800,  0.2, 0.015};
    immutable Bounty gold =    {2500,  2.0, 0.002};
    immutable Bounty sack =    {   0, 25.0, 0.25};

    Bounty best =    {0, 0.0, 0.0};
    Bounty current = {0, 0.0, 0.0};
    Tuple!(int, int, int) bestAmounts;

    immutable maxPanacea = cast(int)(min(sack.weight / panacea.weight,
                                         sack.volume / panacea.volume));
    immutable maxIchor   = cast(int)(min(sack.weight / ichor.weight,
                                         sack.volume / ichor.volume));
    immutable maxGold    = cast(int)(min(sack.weight / gold.weight,
                                         sack.volume / gold.volume));

    foreach (nPanacea; 0 .. maxPanacea)
        foreach (nIchor; 0 .. maxIchor)
            foreach (nGold; 0 .. maxGold) {
                current.value = nPanacea * panacea.value +
                                nIchor * ichor.value +
                                nGold * gold.value;
                current.weight = nPanacea * panacea.weight +
                                 nIchor * ichor.weight +
                                 nGold * gold.weight;
                current.volume = nPanacea * panacea.volume +
                                 nIchor * ichor.volume +
                                 nGold * gold.volume;

                if (current.value > best.value &&
                    current.weight <= sack.weight &&
                    current.volume <= sack.volume) {
                    best = Bounty(current.value,
                                  current.weight,
                                  current.volume);
                    bestAmounts = tuple(nPanacea, nIchor, nGold);
                }
            }

    writeln("Maximum value achievable is ", best.value);
    writefln("This is achieved by carrying (one solution) %d" ~
             " panacea, %d ichor and %d gold", bestAmounts.tupleof);
    writefln("The weight to carry is %4.1f and the volume used is %5.3f",
             best.weight, best.volume);
}
