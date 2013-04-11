import std.stdio, std.algorithm, std.traits;

auto fs(alias f)(in int[] s) /*pure nothrow*/
if (isCallable!f && ParameterTypeTuple!f.length == 1) {
    return map!f(s);
}

int f1(in int x) pure nothrow { return x * 2; }
int f2(in int x) pure nothrow { return x ^^ 2; }

alias fs!f1 fsf1;
alias fs!f2 fsf2;

void main() {
    foreach (d; [[0, 1, 2, 3], [2, 4, 6, 8]]) {
        writeln(fsf1(d));
        writeln(fsf2(d));
    }
}
