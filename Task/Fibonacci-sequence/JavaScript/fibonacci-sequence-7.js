function Y(dn) {
    return (function(fn) {
        return fn(fn);
    }(function(fn) {
        return dn(function() {
            return fn(fn).apply(null, arguments);
        });
    }));
}
var fib = Y(function(fn) {
    return function(n) {
        if (n === 0 || n === 1) {
            return n;
        }
        return fn(n - 1) + fn(n - 2);
    };
});
