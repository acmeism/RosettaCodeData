// compile with --fast for maximum speed...

use Time;

proc countPrimes(lmt: uint(64)): int(64) {
  if lmt < 9 { // when there are no odd primes less than square root...
    if lmt < 3 { if lmt < 2 { return 0; } else { return 1; } }
    return (lmt - (lmt >> 1)): int(64);
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
    proc phi(x: uint(64), a: int): int(64) {
      if a <= 0 { return (x - (x >> 1)): int(64); } // take care of prime of 2
      const na = a - 1; const p = this.oprms[na]: uint(64);
      if x <= p { return 1: int(64); }
      return phi(x, na) - phi(x / p, na);
    }
    proc this(): int(64) {
      return phi(n, this.oprms.size) + this.oprms.size: int(64);
    }
  }
  return (new LegendrePi(lmt))();
}

proc main() {
  var timer: Timer;
  timer.start();

  for i in 0 .. 9 {
    writeln("π(10**", i, ") = ", countPrimesx(10: uint(64) ** i));
  }

  timer.stop();

  writeln("This took ", timer.elapsed(TimeUnits.milliseconds), " milliseconds.");
}
