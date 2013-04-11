import std.stdio, std.algorithm, std.typecons, std.array;

struct Item {
    string name;
    int weight, value;
}

Item[] knapsack01DinamicProg(in Item[] items, in int limit)
pure nothrow {
    auto tab = new int[][](items.length + 1, limit + 1);

    foreach (immutable i, immutable it; items)
        foreach (immutable w; 1 .. limit + 1)
            tab[i + 1][w] = (it.weight > w) ? tab[i][w] :
                max(tab[i][w], tab[i][w - it.weight] + it.value);

    Item[] result;
    int w = limit;
    foreach_reverse (immutable i, immutable it; items)
        if (tab[i + 1][w] != tab[i][w]) {
            w -= it.weight;
            result ~= it;
        }

    return result;
}

void main() {
    enum int limit = 400;
    immutable Item[] items = [{"map",                      9, 150},
                              {"compass",                 13,  35},
                              {"water",                  153, 200},
                              {"sandwich",                50, 160},
                              {"glucose",                 15,  60},
                              {"tin",                     68,  45},
                              {"banana",                  27,  60},
                              {"apple",                   39,  40},
                              {"cheese",                  23,  30},
                              {"beer",                    52,  10},
                              {"suntan cream",            11,  70},
                              {"camera",                  32,  30},
                              {"t-shirt",                 24,  15},
                              {"trousers",                48,  10},
                              {"umbrella",                73,  40},
                              {"waterproof trousers",     42,  70},
                              {"waterproof overclothes",  43,  75},
                              {"note-case",               22,  80},
                              {"sunglasses",               7,  20},
                              {"towel",                   18,  12},
                              {"socks",                    4,  50},
                              {"book",                    30,  10}];

    auto bagged = knapsack01DinamicProg(items, limit);
    writeln("Items to pack:");
    bagged.map!q{ a.name }().array().sort().join("\n").writeln();
    const t = reduce!q{ a[] += [b.weight, b.value][] }([0, 0], bagged);
    const tot_wv = (t[0] <= limit) ? t : [0, 0];
    writefln("\nFor a total weight of %d and a total value of %d",
             tot_wv[0], tot_wv[1]);
}
