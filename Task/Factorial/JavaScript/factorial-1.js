function factorial(n) {
    var x = 1;
    for (var i = 2; i <= n; i++) {
        x *= i;
    }
    return x;
}
