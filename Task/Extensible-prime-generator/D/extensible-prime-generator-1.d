void main() {
    import std.stdio, std.range, std.algorithm, sieve_of_eratosthenes3;

    Prime prime;
    writeln("First twenty primes:\n", 20.iota.map!prime);
    writeln("Primes primes between 100 and 150:\n",
            uint.max.iota.map!prime.until!q{a > 150}.filter!q{a > 99});
    writeln("Number of primes between 7,700 and 8,000: ",
            uint.max.iota.map!prime.until!q{a > 8_000}
            .filter!q{a > 7_699}.walkLength);
    writeln("10,000th prime: ", prime(9_999));
}
