function binom(n, k) {
    var coeff = 1;
    var i;

    if (k < 0 || k > n) return 0;

    for (i = 0; i < k; i++) {
        coeff = coeff * (n - i) / (i + 1);
    }

    return coeff;
}

console.log(binom(5, 3));
