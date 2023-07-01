import std.stdio, std.mathspecial, std.range, std.algorithm,
       std.bigint, std.conv;

enum permutation = (in uint n, in uint k) pure =>
    reduce!q{a * b}(1.BigInt, iota(n - k + 1, n + 1));

enum combination = (in uint n, in uint k) pure =>
    n.permutation(k) / reduce!q{a * b}(1.BigInt, iota(1, k + 1));

enum bigPermutation = (in uint n, in uint k) =>
    exp(logGamma(n + 1) - logGamma(n - k + 1));

enum bigCombination = (in uint n, in uint k) =>
    exp(logGamma(n + 1) - logGamma(n - k + 1) - logGamma(k + 1));

void main() {
    12.permutation(9).writeln;
    12.bigPermutation(9).writeln;
    60.combination(53).writeln;
    145.bigPermutation(133).writeln;
    900.bigCombination(450).writeln;
    1_000.bigCombination(969).writeln;
    15_000.bigPermutation(73).writeln;
    15_000.bigPermutation(1185).writeln;
    writefln("%(%s\\\n%)", 15_000.permutation(74).text.chunks(50));
}
