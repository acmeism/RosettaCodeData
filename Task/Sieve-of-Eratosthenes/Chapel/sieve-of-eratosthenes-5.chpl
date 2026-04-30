use Time;

config const limit = 100000000;

type Prime = uint(32);

class Primes { // needed so we can use next to get successive values
  var n: Prime; var obp: Prime; var q: Prime;
  var bps: owned Primes?;
  var keys: domain(Prime); var dict: [keys] Prime;
  proc next(): Prime { // odd primes!
    if this.n < 5 { this.n = 5; return 3; }
    if this.bps == nil {
      this.bps = new Primes(); // secondary odd base primes feed
      this.obp = this.bps!.next(); this.q = this.obp * this.obp;
    }
    while true {
      if this.n >= this.q { // advance secondary stream of base primes...
        const adv = this.obp * 2; const key = this.q + adv;
        this.obp = this.bps!.next(); this.q = this.obp * this.obp;
        this.keys += key; this.dict[key] = adv;
      }
      else if this.keys.contains(this.n) { // found a composite; advance...
        const adv = this.dict[this.n]; this.keys.remove(this.n);
        var nkey = this.n + adv;
        while this.keys.contains(nkey) do nkey += adv;
        this.keys += nkey; this.dict[nkey] = adv;
      }
      else { const p = this.n; this.n += 2; return p; }
      this.n += 2;
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
