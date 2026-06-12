let bignum = [];
for (let i = 0; i < 1000; i++) {
  bignum.push(Math.floor(Math.random() * 10));
}

let nmax = 0, nmin = 99999;
for (let i = 0; i < 996; i++) {
  const n = Number(bignum.slice(i, i + 5).join(""));
  if (n > nmax) {
    nmax = n;
  } else if (n < nmin) {
    nmin = n;
  }
}

console.log(`Random 1000 digits: ${bignum.join("")}`)
console.log(`Max: ${nmax} | Min: ${nmin}`);
