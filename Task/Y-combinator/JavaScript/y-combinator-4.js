function pseudoY(f) {
    return (function(h) {
        return h(h);
    })(function(h) {
        return f.bind(function() {
            return h(h).apply(null, arguments);
        });
    });
}

var fac = pseudoY(function(n) {
    return n > 1 ? n * this(n - 1) : 1;
});

var fib = pseudoY(function(n) {
    return n > 1 ? this(n - 1) + this(n - 2) : n;
});
