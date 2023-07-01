import std.stdio, std.algorithm, std.string, std.array, std.conv;

void search(immutable(char)*[] items, in int len,
            ref immutable(char)*[] longest) pure {
    if (len > longest.length)
        longest = items[0 .. len].dup;
    immutable lastChar = items[len - 1][1];
    foreach (ref item; items[len .. $])
        if (item[0] == lastChar) {
            swap(items[len], item);
            search(items, len + 1, longest);
            swap(items[len], item);
        }
}

void main() {
    static immutable(char)* prep(in string s) pure {
        assert(s.length > 1);
        auto sd = s.dup;
        swap(sd[1], sd[$ - 1]);
        return sd.toStringz;
    }

     static string unprep(immutable(char)* sd) pure {
        auto ms = sd.to!(char[]);
        swap(ms[1], ms[$ - 1]);
        return ms;
    }

    auto pokemon = "audino bagon baltoy banette bidoof braviary
bronzor carracosta charmeleon cresselia croagunk darmanitan deino
emboar emolga exeggcute gabite girafarig gulpin haxorus heatmor
heatran ivysaur jellicent jumpluff kangaskhan kricketune landorus
ledyba loudred lumineon lunatone machamp magnezone mamoswine nosepass
petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
porygonz registeel relicanth remoraid rufflet sableye scolipede
scrafty seaking sealeo silcoon simisear snivy snorlax spoink starly
tirtouga trapinch treecko tyrogue vigoroth vulpix wailord wartortle
whismur wingull yamask".split.map!prep.array;

    immutable(char)*[] solution;
    foreach (ref name; pokemon) {
        swap(pokemon[0], name);
        search(pokemon, 1, solution);
        swap(pokemon[0], name);
    }

    writefln("%-(%s\n%)", solution.map!unprep);
}
