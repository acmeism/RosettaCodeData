import std.stdio, std.algorithm, std.array;

struct Set(T) {
    immutable T[] items;

    Set opSub(in Set other) const /*pure nothrow*/ {
        return Set(array(filter!(a=> !canFind(other.items,a))(items)));
    }

    Set opAdd(in Set other) const /*pure nothrow*/ {
        return Set(this.items ~ (other - this).items);
    }
}

Set!T symmetricDifference(T)(in Set!T left, in Set!T right) {
    return (left - right) + (right - left);
}

void main() {
    immutable A = Set!string(["John", "Bob", "Mary", "Serena"]);
    immutable B = Set!string(["Jim", "Mary", "John", "Bob"]);

    writeln("        A\\B: ", (A - B).items);
    writeln("        B\\A: ", (B - A).items);
    writeln("A symdiff B: ", symmetricDifference(A, B).items);
}
