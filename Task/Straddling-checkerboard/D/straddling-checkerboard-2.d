import std.stdio, std.algorithm, std.ascii;

struct StraddlingCheckerboard {
  private:
    string[char] table;
    char[10] first, second, third;
    const int rowU, rowV;

  public:
    this(in string alphabet, in int u, in int v) pure nothrow {
        rowU = min(u, v);
        rowV = max(u, v);

        int j = 0;
        foreach (immutable i; 0 .. 10) {
            if (i != u && i != v) {
                first[i] = alphabet[j];
                table[alphabet[j]] = digits[i .. i + 1];
                j++;
            }

            second[i] = alphabet[i + 8];
            table[alphabet[i + 8]] = [digits[rowU], digits[i]];

            third[i] = alphabet[i + 18];
            table[alphabet[i + 18]] = [digits[rowV], digits[i]];
        }
    }

    string encode(in string plain) const pure nothrow {
        string r;
        foreach (immutable char c; plain) {
            if      (c.isLower) r ~= table[c.toUpper];
            else if (c.isUpper) r ~= table[c];
            else if (c.isDigit) r ~= table['/'] ~ c;
        }
        return r;
    }

    string decode(in string cipher) const pure nothrow {
        string r;
        int state = 0;

        foreach (immutable char c; cipher) {
            immutable int n = c - '0';
            char next = '\0';

            if (state == 1)      next = second[n];
            else if (state == 2) next = third[n];
            else if (state == 3) next = c;
            else if (n == rowU)  state = 1;
            else if (n == rowV)  state = 2;
            else                 next = first[n];

            if (next == '/')
                state = 3;
            else if (next != 0) {
                state = 0;
                r ~= next;
            }
        }
        return r;
    }
}

void main() {
    immutable orig =
    "One night-it was on the twentieth of March, 1888-I was returning";
    writeln("Original: ", orig);
    const sc = StraddlingCheckerboard("HOLMESRTABCDFGIJKNPQUVWXYZ./",
                                      3, 7);
    const en = sc.encode(orig);
    writeln("Encoded:  ", en);
    writeln("Decoded:  ", sc.decode(en));
}
