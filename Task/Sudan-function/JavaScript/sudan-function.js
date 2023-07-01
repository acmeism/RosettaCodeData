/**
 * @param {bigint} n
 * @param {bigint} x
 * @param {bigint} y
 * @returns {bigint}
 */
function F(n, x, y) {
  if (n === 0) {
    return x + y;
  }

  if (y === 0) {
    return x;
  }

  return F(n - 1, F(n, x, y - 1), F(n, x, y - 1) + y);
}
