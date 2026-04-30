use BigInteger; use Time;

iter nodupsHamming(): bigint {
  var s2dom = { 0 .. 1023 }; var s2: [s2dom] bigint; // init so can double!
  var s3dom = { 0 .. 1023 }; var s3: [s3dom] bigint; // init so can double!
  s2[0] = 1: bigint; s3[0] = 3: bigint;
  var x5 = 5: bigint; var mrg = 3: bigint;
  var s2hdi, s2tli, s3hdi, s3tli: int;
  while true {
    s2tli += 1;
    if s2hdi + s2hdi >= s2tli { // move in place to avoid allocation!
      s2[0 .. s2tli - s2hdi - 1] = s2[s2hdi .. s2tli - 1];
      s2tli -= s2hdi; s2hdi = 0; }
    const s2sz = s2.size;
    if s2tli >= s2sz then s2dom = { 0 .. s2sz + s2sz - 1 };
    var rslt: bigint; const s2hd = s2[s2hdi];
    if s2hd < mrg { rslt = s2hd; s2hdi += 1; }
    else {
      s3tli += 1;
      if s3hdi + s3hdi >= s2tli { // move in place to avoid allocation!
        s3[0 .. s3tli - s3hdi - 1] = s3[s3hdi .. s3tli - 1];
        s3tli -= s3hdi; s3hdi = 0; }
      const s3sz = s3.size;
      if s3tli >= s3sz then s3dom = { 0 .. s3sz + s3sz - 1 };
      rslt = mrg; s3[s3tli] = rslt * 3;
      s3hdi += 1; const s3hd = s3[s3hdi];
      if s3hd < x5 { mrg = s3hd; }
      else { mrg = x5; x5 = x5 * 5; s3hdi -= 1; }
    }
    s2[s2tli] = rslt * 2;
    yield rslt;
  }
}

// test it...
write("The first 20 hamming numbers are: ");
var cnt = 0: uint(64);
for h in nodupsHamming() {
  if cnt >= 20 then break; cnt += 1; write(" ", h); }

write("\nThe 1691st hamming number is "); cnt = 1;
for h in nodupsHamming() {
  if cnt >= 1691 { writeln(h); break; } cnt += 1; }

write("The millionth hamming number is ");
var timer: Timer; cnt = 1;
timer.start(); var rslt: bigint;
for h in nodupsHamming() {
  if cnt >= 1000000 { rslt = h; break; } cnt += 1; }
timer.stop();
write(rslt);
writeln(".\nThis last took ",
        timer.elapsed(TimeUnits.milliseconds), " milliseconds.");
