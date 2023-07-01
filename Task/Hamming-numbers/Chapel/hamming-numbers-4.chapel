use BigInteger; use Math; use Sort; use Time;

config const nth = 1000000: uint(64);

type TriVal = 3*uint(32);

proc trival2bigint(x: TriVal): bigint {
  proc xpnd(bs: uint, v: uint(32)): bigint {
    var rslt = 1: bigint; var bsm = bs: bigint; var vm = v: uint;
    while vm > 0 { if vm & 1 then rslt *= bsm; bsm *= bsm; vm >>= 1; }
    return rslt;
  }
  const (x2, x3, x5) = x;
  return xpnd(2: uint, x2) * xpnd(3: uint, x3) * xpnd(5: uint, x5);
}

proc nthHamming(n: uint(64)): TriVal {
  if n < 1 {
    writeln("nthHamming - argument must be at least one!"); exit(1); }
  if n < 2 then return (0: uint(32), 0: uint(32), 0: uint(32)); // TriVal for 1

  type LogRep = (real(64), uint(32), uint(32), uint(32));
  record Comparator {} // used for sorting in reverse order!
  proc Comparator.compare(a: LogRep, b: LogRep): real(64) {
    return b[0] - a[0]; }
  var logrepComp: Comparator;

  const lb3 = log2(3.0: real(64)); const lb5 = log2(5.0: real(64));
  const fctr = 6.0: real(64) * lb3 * lb5;
  const crctn = log2(sqrt(30.0: real(64))); // log base 2 of sqrt 30
  // from Wikipedia Regular Numbers formula...
  const lgest = (fctr * n: real(64))**(1.0: real(64) / 3.0: real(64)) - crctn;
  const frctn = if n < 1000000000 then 0.509: real(64) else 0.105: real(64);
  const lghi = (fctr * (n: real(64) + frctn * lgest))**
                 (1.0: real(64) / 3.0: real(64)) - crctn;
  const lglo = 2.0: real(64) * lgest - lghi; // lower limit of the upper "band"
  var count = 0: uint(64); // need to use extended precision, might go over
  var bndi = 0; var dombnd = { 0 .. bndi }; // one value so doubling size works!
  var bnd: [dombnd] LogRep; const klmt = (lghi / lb5): uint(32);
  for k in 0 .. klmt { // i, j, k values can be just uint(32) values!
    const p = k: real(64) * lb5; const jlmt = ((lghi - p) / lb3): uint(32);
    for j in 0 .. jlmt {
      const q = p + j: real(64) * lb3;
      const ir = lghi - q; const lg = q + floor(ir); // current log value (est)
      count += ir: uint(64) + 1;
      if lg >= lglo {
        const sz = dombnd.size; if bndi >= sz then dombnd = { 0..sz + sz - 1 };
        bnd[bndi] = (lg, ir: uint(32), j, k); bndi += 1;
      }
    }
  }
  if n > count {
    writeln("nth_hamming: band high estimate is too low!"); exit(1); }
  dombnd = { 0 .. bndi - 1 }; const ndx = (count - n): int;
  if ndx >= dombnd.size {
    writeln("nth_hamming: band low estimate is too high!"); exit(1); }
  sort(bnd, comparator = logrepComp); // descending order leaves zeros at end!

  const rslt = bnd[ndx]; return (rslt[1], rslt[2], rslt[3]);
}

// test it...
write("The first 20 Hamming numbers are: ");
for i in 1 .. 20 do write(" ", trival2bigint(nthHamming(i: uint(64))));

writeln("\nThe 1691st hamming number is ",
        trival2bigint(nthHamming(1691: uint(64))));

var timer: Timer;
timer.start();
const answr = nthHamming(nth);
timer.stop();
write("The ", nth, "th Hamming number is 2**",
      answr[0], " * 3**", answr[1], " * 5**", answr[2]);
const lgrslt = (answr[0]: real(64) + answr[1]: real(64) * log2(3: real(64)) +
                answr[2]: real(64) * log2(5: real(64))) * log10(2: real(64));
const whl = lgrslt: uint(64); const frac = lgrslt - whl: real(64);
write(",\nwhich is approximately ", 10: real(64)**frac, "E+", whl);
const bganswr = trival2bigint(answr);
const answrstr = bganswr: string; const asz = answrstr.size;
writeln(" and has ", asz, " digits.");
if asz <= 2000 then write("Can be printed as:  ", answrstr);
else write("It's too long to print");
writeln("!\nThis last took ",
        timer.elapsed(TimeUnits.milliseconds), " milliseconds.");
