function gcd_rec(a, b) {
  return b ? gcd_rec(b, a % b) : Math.abs(a);
}
