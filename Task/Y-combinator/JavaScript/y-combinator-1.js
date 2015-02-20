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
