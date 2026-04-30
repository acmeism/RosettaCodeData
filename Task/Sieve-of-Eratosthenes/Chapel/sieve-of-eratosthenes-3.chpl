use Time;
use BitOps;

type Prime = uint(32);

config const limit: Prime = 1000000000; // sieve limit

proc main() {
  write("The first 25 primes are:  ");
  for p in primes(100) do write(p, " "); writeln();

  var count = 0; for p in primes(1000000) do count += 1;
  writeln("Count of primes to a million is:  ", count, ".");

  var timer: Timer;
  timer.start();

  count = 0;
  for p in primes(limit) do count += 1;

  timer.stop();
  write("Found ", count, " primes up to ", limit);
  writeln(" in ", timer.elapsed(TimeUnits.milliseconds), " milliseconds.");
}

iter primes(n: Prime): Prime {
  const szlmt = n / 8;
  var cmpsts: [0 .. szlmt] uint(8); // even number of byte array rounded up

  for bp in 2 .. n {
    if cmpsts[bp >> 3] & (1: uint(8) << (bp & 7)) == 0 {
      const s0 = bp * bp;
      if s0 > n then break;
      for c in s0 .. n by bp { cmpsts[c >> 3] |= 1: uint(8) << (c & 7); }
    }
  }

  for p in 2 .. n do if cmpsts[p >> 3] & (1: uint(8) << (p & 7)) == 0 then yield p;

}
