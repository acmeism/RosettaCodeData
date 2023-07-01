import std.stdio, std.string, std.array;

void parseRPN(in string e) {
    enum nPrec = 9;
    static struct Info { int prec; bool rAssoc; }
    immutable /*static*/ opa = ["^": Info(4, true),
                                "*": Info(3, false),
                                "/": Info(3, false),
                                "+": Info(2, false),
                                "-": Info(2, false)];

    writeln("\nPostfix input: ", e);
    static struct Sf { int prec; string expr; }
    Sf[] stack;
    foreach (immutable tok; e.split()) {
        writeln("Token: ", tok);
        if (tok in opa) {
            immutable op = opa[tok];
            immutable rhs = stack.back;
            stack.popBack();
            auto lhs = &stack.back;
            if (lhs.prec < op.prec ||
                (lhs.prec == op.prec && op.rAssoc))
                lhs.expr = "(" ~ lhs.expr ~ ")";
            lhs.expr ~= " " ~ tok ~ " ";
            lhs.expr ~= (rhs.prec < op.prec ||
                         (rhs.prec == op.prec && !op.rAssoc)) ?
                        "(" ~ rhs.expr ~ ")" :
                        rhs.expr;
            lhs.prec = op.prec;
        } else
            stack ~= Sf(nPrec, tok);
        foreach (immutable f; stack)
            writefln(`    %d "%s"`, f.prec, f.expr);
    }
    writeln("Infix result: ", stack[0].expr);
}

void main() {
    foreach (immutable test; ["3 4 2 * 1 5 - 2 3 ^ ^ / +",
                              "1 2 + 3 4 + ^ 5 6 + ^"])
        parseRPN(test);
}
