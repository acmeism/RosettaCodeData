import std.stdio;

void main() {
    writeln(VectorReal(5, 7) + VectorReal(2, 3));
    writeln(VectorReal(5, 7) - VectorReal(2, 3));
    writeln(VectorReal(5, 7) * 11);
    writeln(VectorReal(5, 7) / 2);
}

alias VectorReal = Vector!real;
struct Vector(T) {
    private T x, y;

    this(T x, T y) {
        this.x = x;
        this.y = y;
    }

    auto opBinary(string op : "+")(Vector rhs) const {
        return Vector(x + rhs.x, y + rhs.y);
    }

    auto opBinary(string op : "-")(Vector rhs) const {
        return Vector(x - rhs.x, y - rhs.y);
    }

    auto opBinary(string op : "/")(T denom) const {
        return Vector(x / denom, y / denom);
    }

    auto opBinary(string op : "*")(T mult) const {
        return Vector(x * mult, y * mult);
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;
        sink.formattedWrite!"(%s, %s)"(x, y);
    }
}
