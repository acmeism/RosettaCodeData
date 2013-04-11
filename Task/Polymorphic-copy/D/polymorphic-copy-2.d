class T {
    this(T t = null) {} // Constructor that will be used for copying.

    override string toString() { return "I'm the instance of T"; }

    T duplicate() { return new T(this); }

    bool custom(char c) { return false; }
}

class S : T {
    char[] str;

    this(S s = null) {
        super(s);
        if (s is null)
            str = ['1', '2', '3']; // All newly created will get that.
        else
            str = s.str.dup; // Do the deep-copy.
    }

    override string toString() {
        return "I'm the instance of S p: " ~ cast(string)str;
    }

    override T duplicate() { return new S(this); }

    // Additional procedure, just to test deep-copy.
    override bool custom(char c) {
        if (str !is null)
            str[0] = c;
        return str is null;
    }
}

void main () {
    import std.stdio;
    T orig = new S;
    orig.custom('X');

    T copy = orig.duplicate();
    orig.custom('Y');

    writeln(orig);
    writeln(copy); // Should have 'X' at the beginning.
}
