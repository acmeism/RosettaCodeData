function compose(f:Function, g:Function):Function {
	return function(x:Number) {return f(g(x));};
}
var functions:Array = [Math.cos, Math.tan, function(x:Number){return x*x;}];
var inverse:Array = [Math.acos, Math.atan, function(x:Number){return Math.sqrt(x);}];

function test() {
	for (var i:uint = 0; i < functions.length; i++) {
		trace(compose(functions[i], inverse[i])(0.5));
	}
}
