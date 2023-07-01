function allEqual(a) {
  var out = true, i = 0;
  while (++i<a.length) {
    out = out && (a[i-1] === a[i]);
  } return out;
}

function azSorted(a) {
  var out = true, i = 0;
  while (++i<a.length) {
    out = out && (a[i-1] < a[i]);
  } return out;
}

var e = ['AA', 'AA', 'AA', 'AA'], s = ['AA', 'ACB', 'BB', 'CC'], empty = [], single = ['AA'];
console.log(allEqual(e)); // true
console.log(allEqual(s)); // false
console.log(allEqual(empty)); // true
console.log(allEqual(single)); // true
console.log(azSorted(e)); // false
console.log(azSorted(s)); // true
console.log(azSorted(empty)); // true
console.log(azSorted(single)); // true
