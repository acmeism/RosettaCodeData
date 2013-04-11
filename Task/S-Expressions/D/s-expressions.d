import std.stdio: write, writeln;
import std.conv: text, parse;
import std.algorithm: canFind;
import std.variant: Variant;
import std.uni: isAlpha, isNumber, isWhite;

alias Sexp = Variant;

struct Symbol {
    private string name;
    string toString() { return name; }
}

Sexp parseSexp(in string raw) {
    static bool isIdentChar(in char c) @safe pure /*nothrow*/ {
        return c.isAlpha || "0123456789!@#-".canFind(c);
    }

    size_t pos = 0;
    while (isWhite(raw[pos])) pos++;
    Sexp _parse() {
        size_t i = pos + 1;
        scope (exit)
            pos = i;
        if (raw[pos] == '"') {
            while (raw[i] != '"' && i < raw.length)
                i++;
            i++;
            return Sexp(raw[pos+1..i-1]);
        } else if (isNumber(raw[pos])) {
            while (isNumber(raw[i]) && i < raw.length)
                i++;
            if (raw[i] == '.') {
                i++;
                while (isNumber(raw[i]) && i < raw.length)
                    i++;
                return Sexp(parse!double(raw[pos .. i]));
            }
            return Sexp(parse!ulong(raw[pos .. i]));
        } else if (isIdentChar(raw[pos])) {
            while (isIdentChar(raw[i]) && i < raw.length)
                i++;
            return Sexp(Symbol(raw[pos .. i]));
        } else if (raw[pos] == '(') {
            Sexp[] lst;
            while (raw[i] != ')') {
                while (isWhite(raw[i]))
                    i++;
                pos = i;
                lst ~= _parse();
                i = pos;
                while (isWhite(raw[i]))
                    i++;
            }
            i = pos + 1;
            return Sexp(lst);
        }
        return Sexp(null);
    }
    return _parse();
}

void writeSexp(Sexp expr) {
    if (expr.type == typeid(string)) {
        write("\"");
        write(expr);
        write("\"");
    } else if (expr.type == typeid(Sexp[])) {
        write("(");
        auto arr = expr.get!(Sexp[]);
        foreach (immutable i, e; arr) {
            writeSexp(e);
            if (i + 1 < arr.length)
                write(" ");
        }
        write(")");
    } else {
        write(expr);
    }
}

void main() {
    auto test = `((data "quoted data" 123 4.5)
     (data (!@# (4.5) "(more" "data)")))`;
    auto pTest = parseSexp(test);
    writeln("Parsed: ", pTest);
    write("Printed: ");
    writeSexp(pTest);
    writeln();
}
