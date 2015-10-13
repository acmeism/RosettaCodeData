function Y(f) {
    var g = f((function(h) {
        return function() {
            var g = f(h(h));
            return g.apply(this, arguments);
        }
    })(function(h) {
        return function() {
            var g = f(h(h));
            return g.apply(this, arguments);
        }
    }));
    return g;
}

var fac = Y(function(f) {
    return function (n) {
        return n > 1 ? n * f(n - 1) : 1;
    };
});

var fib = Y(function(f) {
    return function(n) {
        return n > 1 ? f(n - 1) + f(n - 2) : n;
    };
});
