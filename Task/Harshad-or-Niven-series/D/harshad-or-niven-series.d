import std.stdio, std.algorithm, std.range, std.conv;

void main() {
    auto digsum = (int n) => n.text.map!q{a - '0'}.reduce!q{a + b};
    auto harshads = iota(1, int.max).filter!(n => n % digsum(n) == 0);

    harshads.take(20).writeln;
    harshads.filter!q{ a > 1000 }.front.writeln;
}
