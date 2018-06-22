int fac_aux(int n, int acc) {
    return n < 1 ? acc : fac_aux(n - 1, acc * n);
}

/*Handles negative n, Abhishek Ghosh, 1st November 2017*/

int fac_auxSafe(int n, int acc) {
    return n<0 ? -1 : n < 1 ? acc : fac_aux(n - 1, acc * n);
}

int factorial(int n) {
    return fac_aux(n, 1);
}
