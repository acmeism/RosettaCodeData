import std.stdio;
import std.ascii: letters, U = uppercase, L = lowercase;
import std.string: makeTrans, translate;

immutable r13 = makeTrans(letters,
                          //U[13 .. $] ~ U[0 .. 13] ~
                          U[13 .. U.length] ~ U[0 .. 13] ~
                          L[13 .. L.length] ~ L[0 .. 13]);

void main() {
    writeln("This is the 1st test!".translate(r13, null));
}
