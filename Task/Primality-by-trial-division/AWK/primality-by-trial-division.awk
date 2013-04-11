function prime(n) {
    if (n <= 1) return 0
    for (d = 2; d <= sqrt(n); d++)
        if (!(n % d)) return 0
    return 1
}

{print prime($1)}
