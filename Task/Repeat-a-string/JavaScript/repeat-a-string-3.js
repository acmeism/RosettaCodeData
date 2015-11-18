function nreps(s, n) {
  var o = '';
  if (n < 1) return o;
  while (n > 1) {
    if (n & 1) o += s;
    n >>= 1;
    s += s;
  }
  return o + s;
}

nreps('ha', 50000);
