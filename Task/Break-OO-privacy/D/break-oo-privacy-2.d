import std.stdio;
import breakingprivacy;

void main()
{
    auto foo = Foo([1,2,3], 42, "Hello World!", 3.14);
    writeln(foo);

    // __traits(getMember, obj, name) allows you to access any field of obj given its name
    // Reading a private field
    writeln("foo.x = ", __traits(getMember, foo, "x"));

    // Writing to a private field
    __traits(getMember, foo, "str") = "Not so private anymore!";
    writeln("Modified foo: ", foo);
}
