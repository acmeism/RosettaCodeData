import std.stdio, std.algorithm, std.typecons, std.array, std.range;

struct Item { string name; int weight, value; }

Item[] knapsack01DinamicProgramming(immutable Item[] items, in int limit)
pure nothrow @safe {
    auto tab = new int[][](items.length + 1, limit + 1);

    foreach (immutable i, immutable it; items)
        foreach (immutable w; 1 .. limit + 1)
            tab[i + 1][w] = (it.weight > w) ? tab[i][w] :
                max(tab[i][w], tab[i][w - it.weight] + it.value);

    typeof(return) result;
    int w = limit;
    foreach_reverse (immutable i, immutable it; items)
        if (tab[i + 1][w] != tab[i][w]) {
            w -= it.weight;
            result ~= it;
        }

    return result;
}

void main() @safe {
    enum int limit = 400;
    immutable Item[] items = [
        {"apple",      39,  40}, {"banana",        27,  60},
        {"beer",       52,  10}, {"book",          30,  10},
        {"camera",     32,  30}, {"cheese",        23,  30},
        {"compass",    13,  35}, {"glucose",       15,  60},
        {"map",         9, 150}, {"note-case",     22,  80},
        {"sandwich",   50, 160}, {"socks",          4,  50},
        {"sunglasses",  7,  20}, {"suntan cream",  11,  70},
        {"t-shirt",    24,  15}, {"tin",           68,  45},
        {"towel",      18,  12}, {"trousers",      48,  10},
        {"umbrella",   73,  40}, {"water",        153, 200},
        {"waterproof overclothes", 43, 75},
        {"waterproof trousers",    42, 70}];

    immutable bag = knapsack01DinamicProgramming(items, limit);
    writefln("Items:\n%-(  %s\n%)", bag.map!q{ a.name }.retro);
    const t = reduce!q{ a[] += [b.weight, b.value] }([0, 0], bag);
    writeln("\nTotal weight and value: ", t[0] <= limit ? t : [0, 0]);
}
