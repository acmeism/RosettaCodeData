// This function notation is sorta new, but useful here
// Part of the EcmaScript 6 Draft
// developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions_and_function_scope
var poly = (x => x*x*x - 3*x*x + 2*x);

function sign(x) {
	return (x < 0.0) ? -1 : (x > 0.0) ? 1 : 0;
}

function printRoots(f, lowerBound, upperBound, step) {
	var  x = lowerBound, ox = x,
		 y = f(x), oy = y,
		 s = sign(y), os = s;

	for (; x <= upperBound ; x += step) {
	    s = sign(y = f(x));
	    if (s == 0) {
			console.log(x);
	    }
	    else if (s != os) {
			var dx = x - ox;
			var dy = y - oy;
			var cx = x - dx * (y / dy);
			console.log("~" + cx);
	    }
	    ox = x; oy = y; os = s;
	}
}

printRoots(poly, -1.0, 4, 0.002);
