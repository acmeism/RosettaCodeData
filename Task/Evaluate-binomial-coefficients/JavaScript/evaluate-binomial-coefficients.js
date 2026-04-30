/**
 * Calculates the binomial coefficient n choose k
 *
 * @param {number} n
 * @param {number} k
 */
function nCk(n, k) {
  if (k < 0 || k > n) return 0;

  let result = 1;

  for (let i = 0; i < k; i++) {
    // `result *= (n - i) / (i + 1)` can cause floating point errors
    result = result * (n - i) / (i + 1);
  }

  return result;
}

console.log(nCk(5, 3));
