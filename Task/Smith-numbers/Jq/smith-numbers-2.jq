# input should be an integer
def is_smith:
  def sumdigits:
    tostring|explode|map([.]|implode|tonumber)| add;
  (is_prime|not) and
    (sumdigits == sum(prime_factors|sumdigits));

"Smith numbers up to 10000:\n",
(range(1; 10000) | select(is_smith))
