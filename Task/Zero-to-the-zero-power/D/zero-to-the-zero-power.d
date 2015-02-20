void main() {
    import std.stdio, std.math, std.bigint, std.complex;

    writeln("Int:     ", 0 ^^ 0);
    writeln("Ulong:   ", 0UL ^^ 0UL);
    writeln("Float:   ", 0.0f ^^ 0.0f);
    writeln("Double:  ", 0.0 ^^ 0.0);
    writeln("Real:    ", 0.0L ^^ 0.0L);
    writeln("pow:     ", pow(0, 0));
    writeln("BigInt:  ", 0.BigInt ^^ 0);
    writeln("Complex: ", complex(0.0, 0.0) ^^ 0);
}
