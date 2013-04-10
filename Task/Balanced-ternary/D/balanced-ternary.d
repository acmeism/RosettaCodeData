import std.stdio, std.bigint, std.range, std.algorithm, std.array,
       std.conv, std.exception;

struct BalancedTernary {
    enum Dig : byte { N=-1, Z=0, P=+1 } // digits
    Dig[] digits;
    // Represented as a list of 0, 1 or -1s,
    // with least significant digit first.

    static string dig2str = "-0+";

    const static Dig[dchar] str2dig; // = ['+': Dig.P, ...];
    static this() {
        str2dig = ['+': Dig.P, '-':  Dig.N, '0': Dig.Z];
    }

    immutable static Dig[2][] table =
        [[Dig.Z, Dig.N], [Dig.P, Dig.N], [Dig.N, Dig.Z],
         [Dig.Z, Dig.Z], [Dig.P, Dig.Z], [Dig.N, Dig.P],
         [Dig.Z, Dig.P]];

    this(string inp) {
        this.digits = map!(c => cast()str2dig[c])(retro(inp)).array();
    }

    this(long inp) {
        this.digits = _bint2ternary(BigInt(inp));
    }

    this(BigInt inp) {
        this.digits = _bint2ternary(inp);
    }

    this(BalancedTernary inp) {
        // no need to dup, they are virtually immutable
        this.digits = inp.digits;
    }

    private this(Dig[] inp) {
        this.digits = inp;
    }

    static Dig[] _bint2ternary(/*in*/ BigInt n) {
        static py_div(T1, T2)(T1 a, T2 b) {
            if (a < 0)
                if (b < 0)
                    return -a / -b;
                else
                    return -(-a / b) - (-a % b != 0 ? 1 : 0);
            else if (b < 0)
                    return -(a / -b) - (a % -b != 0 ? 1 : 0);
                else
                    return a / b;
        }

        if (n == 0) return [];
        switch (((n % 3) + 3) % 3) { // (n % 3) is the remainder
            case 0: return Dig.Z ~ _bint2ternary(py_div(n, 3));
            case 1: return Dig.P ~ _bint2ternary(py_div(n, 3));
            case 2: return Dig.N ~ _bint2ternary(py_div(n + 1, 3));
            default: assert(0, "Can't happen");
        }
    }

    @property BigInt toBint() const {
        return reduce!((y,x) => x + 3 * y)(BigInt(0), retro(digits));
    }

    string toString() const {
        if (digits.empty) return "0";
        //return map!(d => dig2str[d + 1])(retro(digits)).array();
        auto r = map!(d => cast()dig2str[d+1])(retro(digits)).array();
        return assumeUnique(r); ///
    }

    static Dig[] neg_(Dig[] digs) {
        return map!(d => -d)(digs).array();
    }

    BalancedTernary opUnary(string op:"-")() {
        return BalancedTernary(neg_(this.digits));
    }

    static Dig[] add_(Dig[] a, Dig[] b, Dig c=Dig.Z) {
        auto a_or_b = a.length ? a : b;
        if (a.empty || b.empty) {
            if (c == Dig.Z)
                return a_or_b;
            else
                return BalancedTernary.add_([c], a_or_b);
        } else {
            // (const d, c) = table[...];
            const dc = table[3 + (a.length ? a[0] : 0) +
                             (b.length ? b[0] : 0) + c];
            auto res = add_(a[1 .. $], b[1 .. $], dc[1]);
            // trim leading zeros
            if (res.length || dc[0] != Dig.Z)
                return [dc[0]] ~ res;
            else
                return res;
        }
    }

    BalancedTernary opBinary(string op:"+")(BalancedTernary b) {
        return BalancedTernary(add_(this.digits, b.digits));
    }

    BalancedTernary opBinary(string op:"-")(BalancedTernary b) {
        return this + (-b);
    }

    static Dig[] mul_(in Dig[] a, /*in*/ Dig[] b) {
        if (a.empty || b.empty) {
            return [];
        } else {
            Dig[] y = Dig.Z ~ mul_(a[1 .. $], b);
            final switch (a[0]) {
                case Dig.N: return add_(neg_(b), y);
                case Dig.Z: return add_([], y);
                case Dig.P: return add_(b, y);
            }
        }
    }

    BalancedTernary opBinary(string op:"*")(BalancedTernary b) {
        return BalancedTernary(mul_(this.digits, b.digits));
    }
}

void main() {
    auto a = BalancedTernary("+-0++0+");
    writeln("a: ", a.toBint, " ", a);

    auto b = BalancedTernary(-436);
    writeln("b: ", b.toBint, " ", b);

    auto c = BalancedTernary("+-++-");
    writeln("c: ", c.toBint, " ", c);

    auto r = a * (b - c);
    writeln("a * (b - c): ", r.toBint, " ", r);
}
