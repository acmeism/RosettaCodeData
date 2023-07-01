class T {
    override string toString() { return "I'm the instance of T"; }
    T duplicate() { return new T; }
}

class S : T {
    override string toString() { return "I'm the instance of S"; }

    override T duplicate() { return new S; }
}

void main () {
    import std.stdio;
    T orig = new S;
    T copy = orig.duplicate();

    writeln(orig);
    writeln(copy);
}
