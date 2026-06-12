function gosper(x) {
  let c = x & -x;
  let r = x + c;
  return Math.floor(((r ^ x) >> 2) / c) | r;
}

function gosper10(x) {
  let a = [];
  for (let i = 0; i < 10; ++i) {
    x = gosper(x);
    a.push(x);
  }
  return a;
}

console.log([1, 3, 7, 15].map(gosper10).join("; "));
