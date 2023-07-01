const TinyPhiPrimes = [ 2, 3, 5, 7, 11, 13 ];
const TinyPhiOddDegree = TinyPhiPrimes.length - 1;
const TinyPhiOddCirc = TinyPhiPrimes.reduce((acc, p) => acc * p) / 2;
const TinyPhiTot = TinyPhiPrimes.reduce((acc, p) => acc * (p - 1), 1)
const TinyPhiLUT = function() {
  const arr = new Uint16Array(TinyPhiOddCirc);  arr.fill(1);
  for (const p of TinyPhiPrimes) {
    if (p <= 2) continue; arr[p >> 1] = 0;
    for (let c = (p * p) >> 1; c < TinyPhiOddCirc; c += p) arr[c] = 0 >>> 0; }
  for (let i = 0 | 0, acc = 0 | 0; i < TinyPhiOddCirc; ++i) {
    acc += arr[i]; arr[i] = acc; }
  return arr; }();
function tinyPhi(x) {
  const ndx = Math.trunc(( x - 1) / 2);
  const numtots = Math.trunc(ndx / TinyPhiOddCirc);
  const rem = (ndx - numtots * TinyPhiOddCirc) >>> 0;
  return numtots * TinyPhiTot + TinyPhiLUT[rem];
}

function countPrimesTo(lmt) {
  if (lmt < 169) {
    if (lmt < 3) { if (lmt < 2) return 0; else return 1; }
    // adjust for the missing "degree" base primes
    if (lmt <= 13) return ((lmt - 1) >>> 1) + (lmt < 9 ? 1 : 0);
    return 5 + TinyPhiLUT[(lmt - 1) >>> 1];
  }
  const sqrtlmt = Math.sqrt(lmt) >>> 0;
  const oprms = function() {
    const mxndx = (sqrtlmt - 3) >>> 1;
    const arr = new Float64Array(mxndx + 1);
    for (let i = 0 >>> 0; i <= mxndx; ++i) arr[i] = (i + i + 3) >>> 0;
    let bp = 3 >>> 0;
    while (true) {
      let i = (bp - 3) >>> 1; let sqri = ((i + i) * (i + 3) + 3) >>> 0;
      if (sqri > mxndx) break;
      if (arr[i] != 0) for (; sqri <= mxndx; sqri += bp) arr[sqri] = 0;
      bp += 2;
    }
    return arr.filter(v => v != 0); }();
  function lvl(pilmt, m) {
    let ans = 0;
    for (let pi = TinyPhiOddDegree; pi < pilmt; ++pi) {
      const p = oprms[pi]; const nm = m * p;
      if (lmt <= nm * p) return ans + pilmt - pi;
      ans += tinyPhi(Math.trunc(lmt / nm));
      if (pi > TinyPhiOddDegree) ans -= lvl(pi, nm);
    }
    return ans;
  }
  return tinyPhi(lmt) - lvl(oprms.length, 1) + oprms.length;
}
