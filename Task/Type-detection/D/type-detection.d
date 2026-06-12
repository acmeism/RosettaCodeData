import std.stdio;

auto typeString(T)(T _) {
    return T.stringof;
}

class C {}
struct S {}

void main() {
    writeln(typeString(1));
    writeln(typeString(1L));
    writeln(typeString(1.0f));
    writeln(typeString(1.0));
    writeln(typeString('c'));
    writeln(typeString("string"));
    writeln(typeString(new C()));
    writeln(typeString(S()));
    writeln(typeString(null));
}
