import std.stdio, std.random;

void main() {
NEXT_STR:
    foreach (j; 1 .. 9) {
        string s;
        foreach (_; 0 .. j * 2)
            s ~= "[]"[uniform(0, 2)];

        int balance;
        foreach (i, c; s) {
            balance += (c == '[') ? 1 : ((c == ']') ? -1 : 0);
            if (balance < 0 || balance >= s.length - i) {
                writefln("BAD: %s (%s)", s, balance < 0 ? "-" : "+");
                continue NEXT_STR;
            }
        }
        writefln(" OK: %s (=)", s);
    }
}
