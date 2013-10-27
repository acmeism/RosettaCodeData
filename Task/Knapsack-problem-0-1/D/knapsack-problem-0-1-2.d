struct Item { string name; int weight, value; }

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

struct Solution { uint bits; int value; }
static assert(items.length <= Solution.bits.sizeof * 8);

void solve(in int weight, in int idx, ref Solution s) pure nothrow {
    if (idx < 0) {
        s.bits = s.value = 0;
        return;
    }

    if (weight < items[idx].weight) {
        solve(weight, idx - 1, s);
        return;
     }

    Solution v1, v2;
    solve(weight, idx - 1, v1);
    solve(weight - items[idx].weight, idx - 1, v2);

    v2.value += items[idx].value;
    v2.bits |= (1 << idx);

    s = (v1.value >= v2.value) ? v1 : v2;
}

void main() {
    import std.stdio;
    auto s = Solution(0, 0);
    solve(400, items.length - 1, s);

    writeln("Items:");
    int w = 0;
    foreach (immutable i, immutable it; items)
        if (s.bits & (1 << i)) {
            writeln("  ", it.name);
            w += it.weight;
        }
    writeln("\nTotal value: %d; weight: %d", s.value, w);
}
