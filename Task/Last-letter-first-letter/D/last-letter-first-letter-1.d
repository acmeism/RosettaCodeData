import std.stdio, std.algorithm, std.string;

void trySwap(string[] items, ref string item, in size_t len, ref string[] longest)
pure nothrow @safe {
    swap(items[len], item);
    search(items, len + 1, longest);
    swap(items[len], item);
}

void search(string[] items, in size_t len, ref string[] longest)
pure nothrow @safe {
    if (len > longest.length)
        longest = items[0 .. len].dup;
    immutable lastChar = items[len - 1][$ - 1];
    foreach (ref item; items[len .. $])
        if (item[0] == lastChar)
            trySwap(items, item, len, longest);
}

void main() @safe {
    auto pokemon = "audino bagon baltoy banette bidoof braviary
bronzor carracosta charmeleon cresselia croagunk darmanitan deino
emboar emolga exeggcute gabite girafarig gulpin haxorus heatmor
heatran ivysaur jellicent jumpluff kangaskhan kricketune landorus
ledyba loudred lumineon lunatone machamp magnezone mamoswine nosepass
petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
porygonz registeel relicanth remoraid rufflet sableye scolipede
scrafty seaking sealeo silcoon simisear snivy snorlax spoink starly
tirtouga trapinch treecko tyrogue vigoroth vulpix wailord wartortle
whismur wingull yamask".split;

    string[] solution;
    foreach (ref name; pokemon)
        trySwap(pokemon, name, 0, solution);

    writefln("%-(%s\n%)", solution);
}
