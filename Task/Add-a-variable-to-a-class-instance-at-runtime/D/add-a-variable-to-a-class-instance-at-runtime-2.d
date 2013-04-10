import std.stdio, std.variant, std.conv;

struct Dyn {
    Variant[string] data;
    alias data this;
}

void main(string[] args) {
    Dyn d;
    const attribute_name = text("attribute_", args.length);
    d[attribute_name] = "something";
    writeln(d[attribute_name]);
}
