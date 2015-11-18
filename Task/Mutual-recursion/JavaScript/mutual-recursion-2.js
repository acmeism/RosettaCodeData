var f = num => (num === 0) ? 1 : num - m(f(num - 1));
var m = num => (num === 0) ? 0 : num - f(m(num - 1));

function range(m, n) {
  return Array.apply(null, Array(n - m + 1)).map(
    function (x, i) { return m + i; }
  );
}

var a = range(0, 19);

//return a new array of the results and join with commas to print
console.log(a.map(n => f(n)).join(', '));
console.log(a.map(n => m(n)).join(', '));
