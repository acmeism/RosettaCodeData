function ethMult(m, n) {
  var o = !isNaN(m) ? 0 : ''; // same technique works with strings
  if (n < 1) return o;
  while (n > 1) {
    if (n & 1) o += m;  // 3. integer odd/even? (bit-wise and 1)
    n >>= 1;            // 1. integer halved (by right-shift)
    m += m;             // 2. integer doubled (addition to self)
  }
  return o + m;
}

ethMult(17, 34)
