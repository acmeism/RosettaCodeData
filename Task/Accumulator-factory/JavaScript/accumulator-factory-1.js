function accumulator(sum) {
  return function(n) {
    return sum += n;
  }
}
var x = accumulator(1);
x(5);
console.log(accumulator(3).toString() + '<br>');
console.log(x(2.3));
