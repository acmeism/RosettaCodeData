// tiny Phi Look Up for `a` of small degree...
const tinyPhiPrimes = [ 2, 3, 5, 7, 11, 13 ]; // degree six
const cC = tinyPhiPrimes.size - 1;
proc product(a: [] int): int {
  var acc = 1; for v in a { acc *= v; }; return acc >> 1; }
const tinyPhiOddCirc = product(tinyPhiPrimes);
proc tot(a: [] int): int {
  var acc = 1; for v in a { acc *= v - 1; }; return acc; }
const tinyPhiOddTot = tot(tinyPhiPrimes);
proc makeTinyLUT(ps: [] int, sz: int): [] uint(32) {
  var arr: [0 .. sz - 1] uint(32) = 1;
  for p in ps {
    if p <= 2 { continue; }
    arr[p >> 1] = 0;
    for c in ((p * p) >> 1) ..< sz by p { arr[c] = 0; }
  }
  var acc = 0: uint(32);
  for i in 0 ..< sz { acc += arr[i]; arr[i] = acc; }
  return arr;
}
const tinyPhiLUT = makeTinyLUT(tinyPhiPrimes, tinyPhiOddCirc);
inline proc tinyPhi(x: uint(64)): int(64) {
  const ndx = (x - 1) >> 1; const numtot = ndx / tinyPhiOddCirc: uint(64);
  return (numtot * tinyPhiOddTot +
            tinyPhiLUT[(ndx - numtot * tinyPhiOddCirc): int]): int(64);
}

proc countPrimes(lmt: uint(64)): int(64) {
  if lmt < 169 { // below 169 whose sqrt is 13 is where TinyPhi doesn't work...
    if lmt < 3 { if lmt < 2 { return 0; } else { return 1; } }
    // adjust for the missing "degree" base primes
    if lmt <= 13 {
      return ((lmt - 1): int(64) >> 1) + (if (lmt < 9) then 1 else 0); }
    return 5 + tinyPhiLUT[(lmt - 1): int >> 1]: int(64);
  }

  // Chapel doesn't have closures, so emulate them with a class...
  class LegendrePi {
    var n: uint(64);
    var dom: domain(1);
    var oprms: [dom] uint(32);
    proc init(n: uint(64)) {
      // first, an array of odd primes to the square root of n is generated...
      this.n = n;
      const sqrtn = sqrt(n: real(64)): int(64);
      const rtlmt = (sqrtn - 3) / 2; this.dom = {0 .. rtlmt};
      this.oprms = 0;
      for i in 0 .. rtlmt do this.oprms[i] = (i + i + 3): uint(32);
      var i = 0;
      for i in (0 ..) { // cull the array
        var ci = (i + i) * (i + 3) + 3; if ci > rtlmt { break; }
        const bp = i + i + 3;
        while (ci <= rtlmt) { this.oprms[ci] = 0; ci += bp; }
      }
      var psz = 0;
      for ti in 0 .. rtlmt { // compress the odd primes array...
        const tv = this.oprms[ti];
        if tv != 0 { this.oprms[psz] = tv; psz += 1; }
      }
      this.dom = { 0 ..< psz };
    }
    proc lvl(pilmt: int, m: uint(64)): int(64) {
      var acc = 0: int(64);
      for pi in cC ..< pilmt {
        const p = this.oprms[pi]: uint(64); const nm = m * p;
        if this.n <= nm * p { return acc + (pilmt - pi); }
        if pi > cC { acc -= this.lvl(pi, nm); }
        const q = this.n / nm; acc += tinyPhi(q);
      }
      return acc;
    }
    proc this(): int(64) {
      return tinyPhi(this.n) - this.lvl(this.oprms.size, 1)
               + this.oprms.size: int(64);
    }
  }
  return (new LegendrePi(lmt))();
}
