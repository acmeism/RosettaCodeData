import std.stdio, std.algorithm, std.typecons, std.range;

alias Bounty = Tuple!(int,"value", double,"weight", double,"volume");

void main() {
    immutable panacea = Bounty(3000,  0.3, 0.025);
    immutable ichor =   Bounty(1800,  0.2, 0.015);
    immutable gold =    Bounty(2500,  2.0, 0.002);
    immutable sack =    Bounty(   0, 25.0, 0.25);

    immutable maxPanacea= cast(int)(min(sack.weight / panacea.weight,
                                        sack.volume / panacea.volume));
    immutable maxIchor  = cast(int)(min(sack.weight / ichor.weight,
                                        sack.volume / ichor.volume));
    immutable maxGold   = cast(int)(min(sack.weight / gold.weight,
                                        sack.volume / gold.volume));

    immutable best =
    cartesianProduct(maxPanacea.iota, maxIchor.iota, maxGold.iota)
    .map!(t => tuple(Bounty(t[0] * panacea.value
                            + t[1] * ichor.value
                            + t[2] * gold.value,
                            t[0] * panacea.weight
                            + t[1] * ichor.weight
                            + t[2] * gold.weight,
                            t[0] * panacea.volume
                            + t[1] * ichor.volume
                            + t[2] * gold.volume), t))
    .filter!(t => t[0].weight <= sack.weight
             && t[0].volume <= sack.volume)
    .reduce!max;

    writeln("Maximum value achievable is ", best[0].value);
    writefln("This is achieved by carrying (one solution) %d" ~
             " panacea, %d ichor and %d gold", best[1].tupleof);
    writefln("The weight to carry is %4.1f and the" ~
             " volume used is %5.3f", best[0].weight, best[0].volume);
}
