function accumulator(sum) function(n) sum += n;
var x = accumulator(1);
x(5);
console.log(accumulator(3).toSource());
console.log(x(2.3));
