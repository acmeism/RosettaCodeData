function Y(f) {
    return function() {
    	return f(Y(f)).apply(this, arguments);
    };
}
