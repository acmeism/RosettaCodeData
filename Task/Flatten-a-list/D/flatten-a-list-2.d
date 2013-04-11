import std.stdio, std.variant, std.range, std.algorithm;

alias T = Algebraic!(int, This[]);

int[] flatten(T t) {
    return t.peek!int ? [t.get!int] : t.get!(T[])().map!flatten.join;
}

void main() {
    T([T([ T(1) ]),
       T(2),
       T([ T([ T(3), T(4) ]), T(5) ]),
       T([ T([ T( T[].init ) ]) ]),
       T([ T([ T([ T(6) ]) ]) ]),
       T(7),
       T(8),
       T( T[].init )
      ]).flatten.writeln;
}
