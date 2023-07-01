var Y = f => (x => x(x))(y => f(x => y(y)(x)));
var fac = Y(f => n => n > 1 ? n * f(n-1) : 1);
