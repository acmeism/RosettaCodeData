import std.stdio, std.algorithm, std.array, std.typecons,
       std.container, std.range;

auto findChain(in string[] seq) pure nothrow /*@safe*/ {
    const adj = seq
                .map!(item => tuple(item, seq
                                          .filter!(x => x[0] == item[$ - 1])
                                          .array))
                .assocArray;
    SList!string res;

    foreach (immutable item; adj.byKey) {
        void inner(in string it, SList!string lst) nothrow {
            lst.insertFront(it);
            if (lst[].walkLength > res[].walkLength)
                res = lst;
            foreach (immutable x; adj[it])
                if (!lst[].canFind(x))
                    inner(x, lst);
        }

        inner(item, SList!string());
    }

    return res.array.retro;
}

void main() /*@safe*/ {
    "audino bagon baltoy banette bidoof braviary
    bronzor carracosta charmeleon cresselia croagunk darmanitan deino
    emboar emolga exeggcute gabite girafarig gulpin haxorus heatmor
    heatran ivysaur jellicent jumpluff kangaskhan kricketune landorus
    ledyba loudred lumineon lunatone machamp magnezone mamoswine
    nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena
    porygon2 porygonz registeel relicanth remoraid rufflet sableye
    scolipede scrafty seaking sealeo silcoon simisear snivy snorlax
    spoink starly tirtouga trapinch treecko tyrogue vigoroth vulpix
    wailord wartortle whismur wingull yamask".split.findChain.writeln;
}
