import std.stdio, std.algorithm, std.range;

auto factors(I)(I n) {
    return iota(1, n + 1).filter!(i => n % i == 0);
}

void main() {
    36.factors.writeln;
}
