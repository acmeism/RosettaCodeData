import std.stdio : writef;

void main() {
    auto sieve = sieve(100);
    for(ulong i = 1; i <= 100; i++) {
        writef("%4d ", min_prime_factor(i, sieve) * max_prime_factor(i, sieve));
        if(i % 10 == 0)
            writef("\n");
    }
}
bool []sieve(ulong max) {
    bool []sieve = new bool[](max + 1);
    sieve[] = true;
    sieve[0] = false;
    sieve[1] = false;

    for(ulong i = 2; i <= max; i++)
        if(sieve[i])
            for(ulong j = i * 2; j <= max; j += i)
                sieve[j] = false;

    return sieve;
}
ulong min_prime_factor(ulong number, bool []sieve) {
    if (number <= 1)
        return 1;

    for(ulong index = 2; index <= number; index++)
        if(sieve[index] && number % index == 0)
            return index;

    assert(0 && "Sieve was not initialized correctly");
}
ulong max_prime_factor(ulong number, bool []sieve) {
    if (number <= 1)
        return 1;

    for(ulong index = number; index >= 2; index--)
        if(sieve[index] && number % index == 0)
            return index;

    assert(0 && "Sieve was not initialized correctly");
}

