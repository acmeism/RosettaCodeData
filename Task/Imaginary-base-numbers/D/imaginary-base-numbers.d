import std.algorithm;
import std.array;
import std.complex;
import std.conv;
import std.format;
import std.math;
import std.stdio;
import std.string;

Complex!double inv(Complex!double v) {
    auto denom = v.re*v.re + v.im*v.im;
    return v.conj / denom;
}

QuaterImaginary toQuaterImaginary(Complex!double v) {
    if (v.re == 0.0 && v.im == 0.0) return QuaterImaginary("0");
    auto re = v.re.to!int;
    auto im = v.im.to!int;
    auto fi = -1;
    auto sb = appender!(char[]);
    while (re != 0) {
        auto rem = re % -4;
        re /= -4;
        if (rem < 0) {
            rem = 4 + rem;
            re++;
        }
        sb.formattedWrite("%d", rem);
        sb.put("0");
    }
    if (im != 0) {
        auto f = (complex(0.0, v.im) / complex(0.0, 2.0)).re;
        im = f.ceil.to!int;
        f = -4.0 * (f - im.to!double);
        auto index = 1;
        while (im != 0) {
            auto rem = im % -4;
            im /= -4;
            if (rem < 0) {
                rem = 4 + rem;
                im++;
            }
            if (index < sb.data.length) {
                sb.data[index] = cast(char)(rem + '0');
            } else {
                sb.put("0");
                sb.formattedWrite("%d", rem);
            }
            index += 2;
        }
        fi = f.to!int;
    }
    sb.data.reverse;
    if (fi != -1) sb.formattedWrite(".%d", fi);
    int i;
    while (i < sb.data.length && sb.data[i] == '0') {
        i++;
    }
    auto s = sb.data[i..$].idup;
    if (s[0] == '.') s = "0" ~ s;
    return QuaterImaginary(s);
}

struct QuaterImaginary {
    private string b2i;

    this(string b2i) {
        if (b2i == "" || b2i.count('.') > 1) {
            throw new Exception("Invalid Base 2i number");
        }
        foreach (c; b2i) {
            if (!canFind("0123.", c)) {
                throw new Exception("Invalid Base 2i number");
            }
        }
        this.b2i = b2i;
    }

    T opCast(T : Complex!double)() {
        auto pointPos = b2i.indexOf('.');
        size_t posLen;
        if (pointPos != -1) {
            posLen = pointPos;
        } else {
            posLen = b2i.length;
        }
        auto sum = complex(0.0, 0.0);
        auto prod = complex(1.0, 0.0);
        foreach (j; 0..posLen) {
            auto k = (b2i[posLen - 1 - j] - '0').to!double;
            if (k > 0.0) {
                sum += prod * k;
            }
            prod *= twoI;
        }
        if (pointPos != -1) {
            prod = invTwoI;
            foreach (j; posLen+1..b2i.length) {
                auto k = (b2i[j] - '0').to!double;
                if (k > 0.0) {
                    sum += prod * k;
                }
                prod *= invTwoI;
            }
        }
        return sum;
    }

    void toString(scope void delegate(const(char)[]) sink, FormatSpec!char fmt) const {
        if (fmt.spec == 's') {
            for (int i=0; i<fmt.width-b2i.length; ++i) {
                sink(" ");
            }
        }
        sink(b2i);
    }

    enum twoI = complex(0.0, 2.0);
    enum invTwoI = twoI.inv;
}

unittest {
    import std.exception;
    assertThrown!Exception(QuaterImaginary(""));
    assertThrown!Exception(QuaterImaginary("1.2.3"));
    assertThrown!Exception(QuaterImaginary("a"));
    assertThrown!Exception(QuaterImaginary("4"));
    assertThrown!Exception(QuaterImaginary(" "));
}

void main() {
    foreach (i; 1..17) {
        auto c1 = complex(i, 0);
        auto qi = c1.toQuaterImaginary;
        auto c2 = cast(Complex!double) qi;
        writef("%4s -> %8s -> %4s     ", c1.re, qi, c2.re);
        c1 = -c1;
        qi = c1.toQuaterImaginary();
        c2 = cast(Complex!double) qi;
        writefln("%4s -> %8s -> %4s", c1.re, qi, c2.re);
    }
    writeln;
    foreach (i; 1..17) {
        auto c1 = complex(0, i);
        auto qi = c1.toQuaterImaginary;
        auto c2 = qi.to!(Complex!double);
        writef("%4si -> %8s -> %4si     ", c1.im, qi, c2.im);
        c1 = -c1;
        qi = c1.toQuaterImaginary();
        c2 = cast(Complex!double) qi;
        writefln("%4si -> %8s -> %4si", c1.im, qi, c2.im);
    }
}
