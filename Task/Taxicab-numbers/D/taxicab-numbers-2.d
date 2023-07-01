import std.stdio, std.string, std.container;

struct CubeSum {
    ulong x, y, value;

    this(in ulong x_, in ulong y_) pure nothrow @safe @nogc {
        this.x = x_;
        this.y = y_;
        this.value = x_ ^^ 3 + y_ ^^ 3;
    }
}

final class Taxi {
    BinaryHeap!(Array!CubeSum, "a.value > b.value") pq;
    CubeSum last;
    ulong n = 0;

    this() {
        last = nextSum();
    }

    CubeSum nextSum() {
        while (pq.empty || pq.front.value >= n ^^ 3)
            pq.insert(CubeSum(++n, 1));

        auto s = pq.front;
        pq.removeFront;
        if (s.x > s.y + 1)
            pq.insert(CubeSum(s.x, s.y + 1));

        return s;
    }

    CubeSum[] nextTaxi() {
        CubeSum s;
        typeof(return) train;

        while ((s = nextSum).value != last.value)
            last = s;

        train ~= last;

        do {
            train ~= s;
        } while ((s = nextSum).value == last.value);
        last = s;

        return train;
    }
}

void main() {
    auto taxi = new Taxi;

    foreach (immutable i; 1 .. 2007) {
        const t = taxi.nextTaxi;
        if (i > 25 && i < 2000)
            continue;

        writef("%4d: %10d", i, t[0].value);
        foreach (const s; t)
            writef(" = %4d^3 + %4d^3", s.x, s.y);
        writeln;
    }
}
