cube(x) { return x * x * x; }
inv_cube(x) { return Math.pow(x, 1/3); }

compo(f1, f2) {
    return func(x) { return f1(f2(x));};
}

main() {
    var funcs = [Math.sin,  Math.exp, cube];
    var invs  = [Math.asin, Math.log, inv_cube];
    for (int i = 0; i < 3; i++)
         print(compo(funcs[i], invs[i])(1));
}
