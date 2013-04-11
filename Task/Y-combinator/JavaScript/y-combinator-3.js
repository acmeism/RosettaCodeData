function Y(f) {
    return (function(h) {
        return h(h);
    })(function(h) {
        return f(function() {
            return h(h).apply(this, arguments);
        });
    });
}
