function Y(f) {
    return function() {
    	return f(arguments.callee).apply(this, arguments);
    };
}
