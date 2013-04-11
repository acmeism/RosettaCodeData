import std.stdio, std.algorithm, std.string, std.conv;

struct Item {
    string name;
    real amount, value;

    @property real valuePerKG() const pure nothrow {
        return value / amount;
    }

    string toString() const /*pure nothrow*/ {
        return format("%10s %7.2f %7.2f %7.2f",
                      name, amount, value, valuePerKG);
    }
}

real sum(string field)(in Item[] items) pure nothrow {
    return reduce!("a + b." ~ field)(0.0L, items);
}

void main() {
    Item[] raw = [{"beef",    3.8, 36.0},
                  {"pork",    5.4, 43.0},
                  {"ham",     3.6, 90.0},
                  {"greaves", 2.4, 45.0},
                  {"flitch",  4.0, 30.0},
                  {"brawn",   2.5, 56.0},
                  {"welt",    3.7, 67.0},
                  {"salami",  3.0, 95.0},
                  {"sausage", 5.9, 98.0}];

    // reverse sorted by Value per amount
    const items = raw.sort!q{a.valuePerKG > b.valuePerKG}().release();

    const(Item)[] chosen;
    real space = 15.0;
    foreach (item; items)
        if (item.amount < space) {
            chosen ~= item;
            space -= item.amount;
        } else {
            chosen ~= Item(item.name, space, item.valuePerKG * space);
            break;
        }

    writefln("%10s %7s %7s %7s", "ITEM", "AMOUNT", "VALUE", "$/unit");
    writefln("%(%s\n%)", chosen);
    writeln(Item("TOTAL", sum!"amount"(chosen), sum!"value"(chosen)));
}
