function simpson_rule(f, a, b, fa, fb) {
  const m = (a + b) / 2;
  const h = b - a;
  const fm = f(m);
  return [(h / 6) * (fa + 4 * fm + fb), m, fm];
}

function recursive_simpson(f, a, b, fa, fb, tol, whole, m, fm, depth) {
  const vleft = simpson_rule(f, a, m, fa, fm);
  const vright = simpson_rule(f, m, b, fm, fb);
  const delta = vleft[0] + vright[0] - whole;
  const tol_new = tol / 2;
  const args_left = [f, a, m, fa, fm, tol_new, vleft, depth-1].flat();
  const args_right = [f, m, b, fm, fb, tol_new, vright, depth-1].flat();
  if (depth <= 0 | tol == tol_new | Math.abs(delta) <= 15 * tol) {
    return vleft[0] + vright[0] + delta / 15;
  } else {
    return recursive_simpson(...args_left) + recursive_simpson(...args_right);
  }
}

function quad_asr(f, a, b, tol, depth) {
  const fa = f(a);
  const fb = f(b);
  const vwhole = simpson_rule(f, a, b, fa, fb);
  const args_whole = [f, a, b, fa, fb, tol, vwhole, depth].flat();
  return recursive_simpson(...args_whole);
}

console.log(quad_asr(Math.sin, 0, 1, 10 ** -9, 10));
