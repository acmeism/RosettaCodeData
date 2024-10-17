##
function DotProduct(a, b: array of real) := a.Zip(b, (x, y) -> x * y).Sum;

DotProduct(|1.0, 3, -5|, |4.0, -2, -1|).println;
