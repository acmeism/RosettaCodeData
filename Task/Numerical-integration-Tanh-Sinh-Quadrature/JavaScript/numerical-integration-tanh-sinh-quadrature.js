function tanhsinh(f, lower, upper, steps, acc) {
  const h = 0.1;
  const h0 = (upper - lower) / 2;
  const h1 = (upper + lower) / 2;
  let rr = 0;
  for (let k = 1; k <= steps; k++) {
    let ro = rr;
    let n = 2 ** k - 1;
    let ss = 0;
    for (let i = -n; i <= n; i++) {
      let t = i * h;
      let sh = Math.sinh(t);
      let ch = Math.cosh(t);
      let th = Math.tanh(sh * Math.PI / 2);
      let dx = (ch * Math.PI / 2) / (Math.cosh(sh * Math.PI / 2) ** 2);
      let xi = h1 + h0 * th;
      let wt = h * dx;
      ss += f(xi) * wt;
    }
    rr = h0 * ss;
    if (Math.abs(rr - ro) < acc) {
      break;
    }
  }
  return rr;
}

console.log(tanhsinh(Math.sin, 0, 1, 5, 10 ** -8));
console.log(tanhsinh(Math.exp, -3, 3, 5, 10 ** -8));
