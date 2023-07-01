// Modular inverse

function modInv(e: number, t: number): number {
  var d = 0;
  if (e < t) {
    var count = 1;
    var bal = e;
    do {
      var step = Math.floor((t - bal) / e) + 1;
      bal += step * e;
      count += step;
      bal -= t;
    } while (bal != 1);
    d = count;
  }
  return d;
}

console.log(`${modInv(42, 2017)}`); // 1969
