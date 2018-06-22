// yield all prime numbers less than limit.
template<class UnaryFunction>
void primesupto(int limit, UnaryFunction yield)
{
  std::vector<bool> is_prime(limit, true);

  const int sqrt_limit = static_cast<int>(std::sqrt(limit));
  for (int n = 2; n <= sqrt_limit; ++n)
    if (is_prime[n]) {
	yield(n);

	for (unsigned k = n*n, ulim = static_cast<unsigned>(limit); k < ulim; k += n)
      //NOTE: "unsigned" is used to avoid an overflow in `k+=n` for `limit` near INT_MAX
	  is_prime[k] = false;
    }

  for (int n = sqrt_limit + 1; n < limit; ++n)
    if (is_prime[n])
	yield(n);
}
