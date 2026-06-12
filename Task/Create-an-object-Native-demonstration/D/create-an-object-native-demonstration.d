struct DefaultAA(TK, TV) {
    TV[TK] standard, current;

    this(TV[TK] default_) pure /*nothrow*/ @safe {
        this.standard = default_;
        this.current = default_.dup;
    }

    alias current this;

    void remove(in TK key) pure nothrow {
        current[key] = standard[key];
    }

    void clear() pure /*nothrow*/ @safe {
        current = standard.dup;
    }
}

void main() {
    import std.stdio;
    auto d = ["a": 1, "b": 2].DefaultAA!(string, int);

    d.writeln;                // ["a":1, "b":2]
    d["a"] = 55; d["b"] = 66;
    d.writeln;                // ["a":55, "b":66]
    d.clear;
    d.writeln;                // ["a":1, "b":2]
    d["a"] = 55; d["b"] = 66;
    d["a"].writeln;           // 55
    d.remove("a");
    d.writeln;                // ["a":1, "b":66]
}
