import std.stdio, std.algorithm, std.typecons, std.array, std.range;

struct Item { string name; int w, v; }
alias Pair = Tuple!(int,"tot", string[],"names");

immutable Item[] items = [{"apple",39,40}, {"banana", 27, 60},
    {"beer", 52, 10}, {"book", 30, 10}, {"camera", 32, 30},
    {"cheese", 23, 30}, {"compass", 13, 35}, {"glucose", 15, 60},
    {"map", 9, 150}, {"note-case", 22, 80}, {"sandwich", 50, 160},
    {"socks", 4, 50}, {"sunglasses", 7, 20}, {"suntan cream", 11, 70},
    {"t-shirt", 24, 15}, {"tin", 68, 45}, {"towel", 18, 12},
    {"trousers", 48, 10}, {"umbrella", 73, 40}, {"water", 153, 200},
    {"overclothes", 43, 75}, {"waterproof trousers", 42, 70}];

auto addItem(Pair[] lst, in Item it) pure /*nothrow*/ {
    auto aux = lst.map!(vn => Pair(vn.tot + it.v, vn.names ~ it.name));
    return lst[0..it.w] ~ lst[it.w..$].zip(aux).map!q{ a[].max }.array;
}

void main() {
    reduce!addItem(Pair().repeat.take(400).array, items).back.writeln;
}
