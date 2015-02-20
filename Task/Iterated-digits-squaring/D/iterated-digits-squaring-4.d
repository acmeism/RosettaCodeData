import std.stdio, std.typecons, std.traits, std.typetuple, std.range, std.algorithm;

auto divMod(T)(T x, T y) pure nothrow @safe @nogc {
    return tuple(x / y, x % y);
}

auto expand(alias F, B)(B x) pure nothrow @safe @nogc
if (isCallable!F &&
    is(ParameterTypeTuple!F == TypeTuple!B)
    && __traits(isSame, TemplateOf!(ReturnType!F), Nullable)
    && isTuple!(TemplateArgsOf!(ReturnType!F)[0])
    && is(TemplateArgsOf!(TemplateArgsOf!(ReturnType!F)[0])[1] == B)) {

    alias NAB = ReturnType!F;
    alias AB = TemplateArgsOf!NAB[0];
    alias A = AB.Types[0];

    struct Expand {
        bool first;
        NAB last;

        @property bool empty() pure nothrow @safe @nogc {
            if (first) {
                first = false;
                popFront;
            }
            return last.isNull;
        }

        @property A front() pure nothrow @safe @nogc {
            if (first) {
                first = false;
                popFront;
            }
            return last.get[0];
        }

        void popFront() pure nothrow @safe @nogc { last = F(last.get[1]); }
    }

    return Expand(true, NAB(AB(A.init, x)));
}

//------------------------------------------------

uint step(uint x) pure nothrow @safe @nogc {
    Nullable!(Tuple!(uint, uint)) f(uint n) pure nothrow @safe @nogc {
        return (n == 0) ? typeof(return)() : typeof(return)(divMod(n, 10u).reverse);
    }

    return expand!f(x).map!(x => x ^^ 2).sum;
}

uint iter(uint x) pure nothrow @nogc {
    return x.recurrence!((a, n) => step(a[n - 1])).filter!(y => y.among!(1, 89)).front;
}

void main() {
    iota(1u, 100_000u).filter!(n => n.iter == 89).count.writeln;
}
