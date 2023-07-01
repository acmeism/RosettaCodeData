use Time;

use Map;

config const limit = 100000000;

type Prime = uint(32);

class Primes { // needed so we can use next to get successive values
  record PrimeR { var prime: Prime; proc hash() { return prime; } }
  var n: PrimeR = new PrimeR(0); var obp: Prime; var q: Prime;
  var bps: owned Primes?;
  var dict = new map(PrimeR, Prime);
  proc next(): Prime { // odd primes!
    if this.n.prime < 5 { this.n.prime = 5; return 3; }
    if this.bps == nil {
      this.bps = new Primes(); // secondary odd base primes feed
      this.obp = this.bps!.next(); this.q = this.obp * this.obp;
    }
    while true {
      if this.n.prime >= this.q { // advance secondary stream of base primes...
        const adv = this.obp * 2; const key = new PrimeR(this.q + adv);
        this.obp = this.bps!.next(); this.q = this.obp * this.obp;
        this.dict.add(key, adv);
      }
      else if this.dict.contains(this.n) { // found a composite; advance...
        const adv = this.dict.getValue(this.n); this.dict.remove(this.n);
        var nkey = new PrimeR(this.n.prime + adv);
        while this.dict.contains(nkey) do nkey.prime += adv;
        this.dict.add(nkey, adv);
      }
      else { const p = this.n.prime;
             this.n.prime += 2; return p; }
      this.n.prime += 2;
    }
    return 0; // to keep compiler happy in returning a value!
  }
  iter these(): Prime { yield 2; while true do yield this.next(); }
}

proc main() {
  var count = 0;
  write("The first 25 primes are:  ");
  for p in new Primes() { if count >= 25 then break; write(p, " "); count += 1; }
  writeln();

  var timer: Timer;
  timer.start();

  count = 0;
  for p in new Primes() { if p > limit then break; count += 1; }

  timer.stop();
  write("Found ", count, " primes up to ", limit);
  writeln(" in ", timer.elapsed(TimeUnits.milliseconds), " milliseconds.");
}
