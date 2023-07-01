import std.stdio;

int inv(int a) {
    return a ^ -1;
}

class Zeckendorf {
    private int dVal;
    private int dLen;

    private void a(int n) {
        auto i = n;
        while (true) {
            if (dLen < i) dLen = i;
            auto j = (dVal >> (i * 2)) & 3;
            switch(j) {
                case 0:
                case 1:
                    return;
                case 2:
                    if (((dVal >> ((i + 1) * 2)) & 1) != 1) return;
                    dVal += 1 << (i * 2 + 1);
                    return;
                case 3:
                    dVal = dVal & (3 << (i * 2)).inv();
                    b((i + 1) * 2);
                    break;
                default:
                    assert(false);
            }
            i++;
        }
    }

    private void b(int pos) {
        if (pos == 0) {
            this++;
            return;
        }
        if (((dVal >> pos) & 1) == 0) {
            dVal += 1 << pos;
            a(pos / 2);
            if (pos > 1) a(pos / 2 - 1);
        } else {
            dVal = dVal & (1 << pos).inv();
            b(pos + 1);
            b(pos - (pos > 1 ? 2 : 1));
        }
    }

    private void c(int pos) {
        if (((dVal >> pos) & 1) == 1) {
            dVal = dVal & (1 << pos).inv();
            return;
        }
        c(pos + 1);
        if (pos > 0) {
            b(pos - 1);
        } else {
            ++this;
        }
    }

    this(string x = "0") {
        int q = 1;
        int i = x.length - 1;
        dLen = i / 2;
        while (i >= 0) {
            dVal += (x[i] - '0') * q;
            q *= 2;
            i--;
        }
    }

    auto opUnary(string op : "++")() {
        dVal += 1;
        a(0);
        return this;
    }

    void opOpAssign(string op : "+")(Zeckendorf rhs) {
        foreach (gn; 0..(rhs.dLen + 1) * 2) {
            if (((rhs.dVal >> gn) & 1) == 1) {
                b(gn);
            }
        }
    }

    void opOpAssign(string op : "-")(Zeckendorf rhs) {
        foreach (gn; 0..(rhs.dLen + 1) * 2) {
            if (((rhs.dVal >> gn) & 1) == 1) {
                c(gn);
            }
        }
        while ((((dVal >> dLen * 2) & 3) == 0) || (dLen == 0)) {
            dLen--;
        }
    }

    void opOpAssign(string op : "*")(Zeckendorf rhs) {
        auto na = rhs.dup;
        auto nb = rhs.dup;
        Zeckendorf nt;
        auto nr = "0".Z;
        foreach (i; 0..(dLen + 1) * 2) {
            if (((dVal >> i) & 1) > 0) nr += nb;
            nt = nb.dup;
            nb += na;
            na = nt.dup;
        }
        dVal = nr.dVal;
        dLen = nr.dLen;
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        if (dVal == 0) {
            sink("0");
            return;
        }
        sink(dig1[(dVal >> (dLen * 2)) & 3]);
        foreach_reverse (i; 0..dLen) {
            sink(dig[(dVal >> (i * 2)) & 3]);
        }
    }

    Zeckendorf dup() {
        auto z = "0".Z;
        z.dVal = dVal;
        z.dLen = dLen;
        return z;
    }

    enum dig = ["00", "01", "10"];
    enum dig1 = ["", "1", "10"];
}

auto Z(string val) {
    return new Zeckendorf(val);
}

void main() {
    writeln("Addition:");
    auto g = "10".Z;
    g += "10".Z;
    writeln(g);
    g += "10".Z;
    writeln(g);
    g += "1001".Z;
    writeln(g);
    g += "1000".Z;
    writeln(g);
    g += "10101".Z;
    writeln(g);
    writeln();

    writeln("Subtraction:");
    g = "1000".Z;
    g -= "101".Z;
    writeln(g);
    g = "10101010".Z;
    g -= "1010101".Z;
    writeln(g);
    writeln();

    writeln("Multiplication:");
    g = "1001".Z;
    g *= "101".Z;
    writeln(g);
    g = "101010".Z;
    g += "101".Z;
    writeln(g);
}
