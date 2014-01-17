import std.stdio, std.algorithm, std.string;

struct Item {
    string name;
    real amount, value;

    @property real valuePerKG() @safe const pure nothrow {
        return value / amount;
    }

    string toString() const /*pure nothrow*/ {
        return format("%10s %7.2f %7.2f %7.2f",
                      name, amount, value, valuePerKG);
    }
}

real sumBy(string field)(in Item[] items) @safe pure nothrow {
    return reduce!("a + b." ~ field)(0.0L, items);
}

void main() {
    const items = [Item("beef",    3.8, 36.0),
                   Item("pork",    5.4, 43.0),
                   Item("ham",     3.6, 90.0),
                   Item("greaves", 2.4, 45.0),
                   Item("flitch",  4.0, 30.0),
                   Item("brawn",   2.5, 56.0),
                   Item("welt",    3.7, 67.0),
                   Item("salami",  3.0, 95.0),
                   Item("sausage", 5.9, 98.0)]
                  .schwartzSort!(it => -it.valuePerKG)
                  .release;

    immutable(Item)[] chosen;
    real space = 15.0;
    foreach (const item; items)
        if (item.amount < space) {
            chosen ~= item;
            space -= item.amount;
        } else {
            chosen ~= Item(item.name, space, item.valuePerKG * space);
            break;
        }

    writefln("%10s %7s %7s %7s", "ITEM", "AMOUNT", "VALUE", "$/unit");
    writefln("%(%s\n%)", chosen);
    Item("TOTAL", chosen.sumBy!"amount", chosen.sumBy!"value").writeln;
}
