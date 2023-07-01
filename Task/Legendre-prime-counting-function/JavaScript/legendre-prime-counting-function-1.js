"use strict";

function countPrimesTo(lmt) {
  if (lmt < 3) { if (lmt < 2) return 0; else return 1; }
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
    return arr.filter(v => v != 0);
  }();
  function phi(x, a) {
    if (a <= 0) return x - Math.trunc(x / 2);
    const na = (a - 1) >>> 0; const p = oprms[na];
    if (x <= p) return 1;
    return phi(x, na) - phi(Math.trunc(x / p), na);
  }
  return phi(lmt, oprms.length) + oprms.length;
}

const start = Date.now();
for (let i = 0; i <= 9; ++i) console.log(`π(10**${i}) =`, countPrimesTo(10**i));
const elpsd = Date.now() - start;
console.log("This took", elpsd, "milliseconds.")
