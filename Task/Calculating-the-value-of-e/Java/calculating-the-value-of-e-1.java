double e(long limit) {
    double e = 1;
    for (long term = 1; term <= limit; term++)
        e += 1d / factorial(term);
    return e;
}

long factorial(long value) {
    return value == 1 ? value : value * factorial(--value);
}
