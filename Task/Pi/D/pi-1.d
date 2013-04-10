import std.stdio, std.conv, std.string;

struct PiDigits {
    immutable uint nDigits;

    int opApply(int delegate(ref string /*chunk of pi digit*/) dg){
        // Maximum width for correct output, for type ulong.
        enum size_t width = 9;

        enum ulong scale = 10UL ^^ width;
        enum ulong initDigit = 2UL * 10UL ^^ (width - 1);
        enum string formatString = "%0" ~ text(width) ~ "d";

        immutable size_t len = 10 * nDigits / 3;
        auto arr = new ulong[len];
        arr[] = initDigit;
        ulong carry;

        foreach (i; 0 .. nDigits / width) {
            ulong sum;
            foreach_reverse (j; 0 .. len) {
                auto quo = sum * (j + 1) + scale * arr[j];
                arr[j] = quo % (j*2 + 1);
                sum = quo / (j*2 + 1);
            }
            auto yield = format(formatString, carry + sum/scale);
            if (dg(yield))
                break;
            carry = sum % scale;
        }
        return 0;
    }
}

void main() {
    foreach (d; PiDigits(100))
        writeln(d);
}
