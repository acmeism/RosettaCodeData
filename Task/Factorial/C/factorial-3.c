int fac_aux(int n, int acc) {
    return n < 1 ? acc : fac_aux(n - 1, acc * n);
}

int factorial(int n) {
    return fac_aux(n, 1);
}
