function poly_deriv(a) {
  for (let i = 0; i < a.length; i++) {
    a[i] = a[i + 1] * (i + 1);
  }
  a.pop();
  return a;
}

const test_polys = [[5], [4, -3], [-1, 6, 5], [-4, 3, -2, 1], [1, 1, 0, -1, -1]];
test_polys.forEach(a => console.log(poly_deriv(a)));
