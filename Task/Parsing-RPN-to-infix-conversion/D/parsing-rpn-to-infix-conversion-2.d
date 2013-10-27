import std.stdio, std.typecons, std.string, std.array, std.algorithm;

void rpmToInfix(in string str) {
    alias Exp = Tuple!(int,"p", string,"e");
    immutable P = (in Exp pair, in int prec) pure =>
        pair.p < prec ? format("( %s )", pair.e) : pair.e;
    immutable F = (string[] s...) pure nothrow => s.join(" ");

    writefln("=================\n%s", str);
    Exp[] stack;
    foreach (const w; str.split) {
        if (w.isNumeric)
            stack ~= Exp(9, w);
        else {
            const y = stack.back; stack.popBack;
            const x = stack.back; stack.popBack;
            switch (w) {
                case "^": stack ~= Exp(4, F(P(x, 5), w, P(y, 4)));
                    break;
                case "*", "/": stack ~= Exp(3, F(P(x, 3), w, P(y, 3)));
                    break;
                case "+", "-": stack ~= Exp(2, F(P(x, 2), w, P(y, 2)));
                    break;
                default: throw new Error("Wrong part: " ~ w);
            }
        }
        stack.map!q{ a[1] }.writeln;
    }
    writeln("-----------------\n", stack.back.e);
}

void main() {
    "3 4 2 * 1 5 - 2 3 ^ ^ / +".rpmToInfix;
    "1 2 + 3 4 + ^ 5 6 + ^".rpmToInfix;
}
