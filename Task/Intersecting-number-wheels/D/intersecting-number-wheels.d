import std.exception;
import std.range;
import std.stdio;

struct Wheel {
    private string[] values;
    private uint index;

    invariant {
        enforce(index < values.length, "index out of range");
    }

    this(string[] value...) in {
        enforce(value.length > 0, "Cannot create a wheel with no elements");
    } body {
        values = value;
    }

    enum empty = false;

    auto front() {
        return values[index];
    }

    void popFront() {
        index = (index + 1) % values.length;
    }
}

struct NamedWheel {
    private Wheel[char] wheels;
    char m;

    this(char c, Wheel w) {
        add(c, w);
        m = c;
    }

    void add(char c, Wheel w) {
        wheels[c] = w;
    }

    enum empty = false;

    auto front() {
        auto v = wheels[m].front;
        char c = v[0];
        while ('A' <= c && c <= 'Z') {
            v = wheels[c].front;
            c = v[0];
        }
        return v;
    }

    void popFront() {
        auto v = wheels[m].front;
        wheels[m].popFront;

        char c = v[0];
        while ('A' <= c && c <= 'Z') {
            auto d = wheels[c].front;
            wheels[c].popFront;
            c = d[0];
        }
    }
}

void group1() {
    auto a = Wheel("1", "2", "3");
    a.take(20).writeln;
}

void group2() {
    auto a = Wheel("1", "B", "2");
    auto b = Wheel("3", "4");

    auto n = NamedWheel('A', a);
    n.add('B', b);

    n.take(20).writeln;
}

void group3() {
    auto a = Wheel("1", "D", "D");
    auto d = Wheel("6", "7", "8");

    auto n = NamedWheel('A', a);
    n.add('D', d);

    n.take(20).writeln;
}

void group4() {
    auto a = Wheel("1", "B", "C");
    auto b = Wheel("3", "4");
    auto c = Wheel("5", "B");

    auto n = NamedWheel('A', a);
    n.add('B', b);
    n.add('C', c);

    n.take(20).writeln;
}

void main() {
    group1();
    group2();
    group3();
    group4();
}
