import std.stdio, std.algorithm;

void main() {
    static struct T { string item; double weight, price; }
    auto items = [T("beef",    3.8, 36.0),
                  T("pork",    5.4, 43.0),
                  T("ham",     3.6, 90.0),
                  T("greaves", 2.4, 45.0),
                  T("flitch",  4.0, 30.0),
                  T("brawn",   2.5, 56.0),
                  T("welt",    3.7, 67.0),
                  T("salami",  3.0, 95.0),
                  T("sausage", 5.9, 98.0)];
    sort!q{a.price/a.weight > b.price/b.weight}(items);

    auto left = 15.0;
    foreach (it; items) {
        if (it.weight <= left) {
            writeln("Take all the ", it.item);
            if (it.weight == left)
                return;
            left -= it.weight;
        } else {
            writefln("Take %.1fkg %s", left, it.item);
            return;
        }
    }
}
