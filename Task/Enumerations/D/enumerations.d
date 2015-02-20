void main() {
    // Named enumeration (commonly used enum in D).
    // The underlying type is a 32 bit int.
    enum Fruits1 { apple, banana, cherry }

    // You can assign an enum to the general type, but not the opposite:
    int f1 = Fruits1.banana; // No error.
    // Fruits1 f2 = 1; // Error: cannot implicitly convert.

    // Anonymous enumeration, as in C, of type 32 bit int.
    enum { APPLE, BANANA, CHERRY }
    static assert(CHERRY == 2);

    // Named enumeration with specified values (int).
    enum Fruits2 { apple = 0, banana = 10, cherry = 20 }

    // Named enumeration, typed and with specified values.
    enum Fruits3 : ubyte { apple = 0, banana = 100, cherry = 200 }

    // Named enumeration, typed and with partially specified values.
    enum Test : ubyte { A = 2, B, C = 3 }
    static assert(Test.B == 3); // Uses the next ubyte, duplicated value.

    // This raises a compile-time error for overflow.
    // enum Fruits5 : ubyte { apple = 254, banana = 255, cherry }

    enum Component {
        none,
        red   = 2 ^^ 0,
        green = 2 ^^ 1,
        blue  = 2 ^^ 2
    }

    // Phobos BitFlags support all the most common operations on flags.
    // Some of the operations are shown below.
    import std.typecons: BitFlags;

    alias ComponentFlags = BitFlags!Component;
    immutable ComponentFlags flagsEmpty;

    // Value can be set with the | operator.
    immutable flagsRed = flagsEmpty | Component.red;

    immutable flagsGreen = ComponentFlags(Component.green);
    immutable flagsRedGreen = ComponentFlags(Component.red, Component.green);
    immutable flagsBlueGreen = ComponentFlags(Component.blue, Component.green);

    // Use the & operator between BitFlags for intersection.
    assert (flagsGreen == (flagsRedGreen & flagsBlueGreen));
}
