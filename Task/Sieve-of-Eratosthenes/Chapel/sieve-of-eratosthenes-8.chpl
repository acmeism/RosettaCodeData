use Time;

type Prime = uint(32);

config const limit = 1000000: Prime;

// Chapel doesn't have closures, so we need to emulate them with classes...
class PrimeCIS { // base prime stream...
  var head: Prime;
  proc next(): shared PrimeCIS { return new shared PrimeCIS(); }
}

class PrimeMultiples: PrimeCIS {
  var adv: Prime;
  override proc next(): shared PrimeCIS {
    return new shared PrimeMultiples(
      this.head + this.adv, this.adv): shared PrimeCIS; }
}

class PrimeCISCIS { // base stream of prime streams; never used directly...
  var head: shared PrimeCIS;
  proc init() { this.head = new shared PrimeCIS(); }
  proc next(): shared PrimeCISCIS {
    return new shared PrimeCISCIS(); }
}

class AllMultiples: PrimeCISCIS {
  var bps: shared PrimeCIS;
  proc init(bsprms: shared PrimeCIS) {
    const bp = bsprms.head; const sqr = bp * bp; const adv = bp + bp;
    this.head = new shared PrimeMultiples(sqr, adv): PrimeCIS;
    this.bps = bsprms;
  }
  override proc next(): shared PrimeCISCIS {
    return new shared AllMultiples(this.bps.next()): PrimeCISCIS; }
}

class Union: PrimeCIS {
  var feeda, feedb: shared PrimeCIS;
  proc init(fda: shared PrimeCIS, fdb: shared PrimeCIS) {
    const ahd = fda.head; const bhd = fdb.head;
    this.head = if ahd < bhd then ahd else bhd;
    this.feeda = fda; this.feedb = fdb;
  }
  override proc next(): shared PrimeCIS {
    const ahd = this.feeda.head; const bhd = this.feedb.head;
    if ahd < bhd then
      return new shared Union(this.feeda.next(), this.feedb): shared PrimeCIS;
    if ahd > bhd then
      return new shared Union(this.feeda, this.feedb.next()): shared PrimeCIS;
    return new shared Union(this.feeda.next(),
                            this.feedb.next()): shared PrimeCIS;
  }
}

class Pairs: PrimeCISCIS {
  var feed: shared PrimeCISCIS;
  proc init(fd: shared PrimeCISCIS) {
    const fs = fd.head; const sss = fd.next(); const ss = sss.head;
    this.head = new shared Union(fs, ss): shared PrimeCIS; this.feed = sss;
  }
  override proc next(): shared PrimeCISCIS {
    return new shared Pairs(this.feed.next()): shared PrimeCISCIS; }
}

class Composites: PrimeCIS {
  var feed: shared PrimeCISCIS;
  proc init(fd: shared PrimeCISCIS) {
    this.head = fd.head.head; this.feed = fd;
  }
  override proc next(): shared PrimeCIS {
    const fs = this.feed.head.next();
    const prs = new shared Pairs(this.feed.next()): shared PrimeCISCIS;
    const ncs = new shared Composites(prs): shared PrimeCIS;
    return new shared Union(fs, ncs): shared PrimeCIS;
  }
}

class OddPrimesFrom: PrimeCIS {
  var cmpsts: shared PrimeCIS;
  override proc next(): shared PrimeCIS {
    var n = head + 2; var cs = this.cmpsts;
    while true {
      if n < cs.head then
        return new shared OddPrimesFrom(n, cs): shared PrimeCIS;
      n += 2; cs = cs.next();
    }
    return this.cmpsts; // never used; keeps compiler happy!
  }
}

class OddPrimes: PrimeCIS {
  proc init() { this.head = 3; }
  override proc next(): shared PrimeCIS {
    const bps = new shared OddPrimes(): shared PrimeCIS;
    const mlts = new shared AllMultiples(bps): shared PrimeCISCIS;
    const cmpsts = new shared Composites(mlts): shared PrimeCIS;
    return new shared OddPrimesFrom(5, cmpsts): shared PrimeCIS;
  }
}

iter primes(): Prime {
  yield 2; var cur = new shared OddPrimes(): shared PrimeCIS;
  while true { yield cur.head; cur = cur.next(); }
}

// test it...
write("The first 25 primes are: "); var cnt = 0;
for p in primes() { if cnt >= 25 then break; cnt += 1; write(" ", p); }

Time as run using Chapel version 24.1 on an Intel Skylake i5-6500 at 3.6 GHz (turbo, single threaded).

var timer: Timer; timer.start(); cnt = 0;
for p in primes() { if p > limit then break; cnt += 1; }
timer.stop(); write("\nFound ", cnt, " primes up to ", limit);
writeln(" in ", timer.elapsed(TimeUnits.milliseconds), " milliseconds.");
