function pseudoY(f) {
    return function g() {
        return f.apply(g, arguments);
    };
}

var fac = pseudoY(function(n) {
    return n > 1 ? n * this(n - 1) : 1;
});

var fib = pseudoY(function(n) {
    return n > 1 ? this(n - 1) + this(n - 2) : n;
});
