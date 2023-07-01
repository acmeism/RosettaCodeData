// Gray code

function encode(v: number): number {
  return v ^ (v >> 1);
}

function decode(v: number): number {
  var result = 0;
  while (v > 0) {
    result ^= v;
    v >>= 1;
  }
  return result;
}

console.log("decimal  binary   gray    decoded");
for (var i = 0; i <= 31; i++) {
  var g = encode(i);
  var d = decode(g);
  process.stdout.write(
    "  " + i.toString().padStart(2, " ") +
    "     " + i.toString(2).padStart(5, "0") +
    "   " + g.toString(2).padStart(5, "0") +
    "   " + d.toString(2).padStart(5, "0") +
    "  " + d.toString().padStart(2, " "));
  console.log();
}
