use BigInteger; use Math; use Time;

config const nth: uint(64) = 1000000;

const lb2 = 1: real(64); // log base 2 of 2!
const lb3 = log2(3: real(64)); const lb5 = log2(5: real(64));
record LogRep {
  var lg: real(64); var x2: uint(32);
  var x3: uint(32); var x5: uint(32);
  inline proc mul2(): LogRep {
    return new LogRep(this.lg + lb2, this.x2 + 1, this.x3, this.x5); }
  inline proc mul3(): LogRep {
    return new LogRep(this.lg + lb3, this.x2, this.x3 + 1, this.x5); }
  inline proc mul5(): LogRep {
    return new LogRep(this.lg + lb5, this.x2, this.x3, this.x5 + 1); }
  proc lr2bigint(): bigint {
    proc xpnd(bs: uint, v: uint(32)): bigint {
      var rslt = 1: bigint; var bsm = bs: bigint; var vm = v: uint;
      while vm > 0 { if vm & 1 then rslt *= bsm; bsm *= bsm; vm >>= 1; }
      return rslt;
    }
    return xpnd(2: uint, this.x2) *
             xpnd(3: uint, this.x3) * xpnd(5: uint, this.x5);
  }
  proc writeThis(lr) throws {
    lr <~> this.lr2bigint();
  }
}
operator <(const ref a: LogRep, const ref b: LogRep): bool { return a.lg < b.lg; }
const one = new LogRep(0, 0, 0, 0);

iter nodupsHammingLog(): LogRep {
  var s2dom = { 0 .. 1023 }; var s2: [s2dom] LogRep; // init so can double!
  var s3dom = { 0 .. 1023 }; var s3: [s3dom] LogRep; // init so can double!
  s2[0] = one; s3[0] = one.mul3();
  var x5 = one.mul5(); var mrg = one.mul3();
  var s2hdi, s2tli, s3hdi, s3tli: int;
  while true {
    s2tli += 1;
    if s2hdi + s2hdi >= s2tli { // move in place to avoid allocation!
      s2[0 .. s2tli - s2hdi - 1] = s2[s2hdi .. s2tli - 1];
      s2tli -= s2hdi; s2hdi = 0; }
    const s2sz = s2.size;
    if s2tli >= s2sz then s2dom = { 0 .. s2sz + s2sz - 1 };
    var rslt: LogRep; const s2hd = s2[s2hdi];
    if s2hd.lg < mrg.lg { rslt = s2hd; s2hdi += 1; }
    else {
      s3tli += 1;
      if s3hdi + s3hdi >= s2tli { // move in place to avoid allocation!
        s3[0 .. s3tli - s3hdi - 1] = s3[s3hdi .. s3tli - 1];
        s3tli -= s3hdi; s3hdi = 0; }
      const s3sz = s3.size;
      if s3tli >= s3sz then s3dom = { 0 .. s3sz + s3sz - 1 };
      rslt = mrg; s3[s3tli] = mrg.mul3(); s3hdi += 1;
      const s3hd = s3[s3hdi];
      if s3hd.lg < x5.lg { mrg = s3hd; }
      else { mrg = x5; x5 = x5.mul5(); s3hdi -= 1; }
    }
    s2[s2tli] = rslt.mul2();
    yield rslt;
  }
}

// test it...
write("The first 20 hamming numbers are: ");
var cnt = 0: uint(64);
for h in nodupsHammingLog() {
  if cnt >= 20 then break; cnt += 1; write(" ", h); }

write("\nThe 1691st hamming number is "); cnt = 1;
for h in nodupsHammingLog() {
  if cnt >= 1691 { writeln(h); break; } cnt += 1; }

write("The ", nth, "th hamming number is ");
var timer: Timer; cnt = 1;
timer.start(); var rslt: LogRep;
for h in nodupsHammingLog() {
  if cnt >= nth { rslt = h; break; } cnt += 1; }
timer.stop();
write(rslt);
writeln(".\nThis last took ",
        timer.elapsed(TimeUnits.milliseconds), " milliseconds.");
