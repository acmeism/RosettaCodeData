# Output: primes whose decimal representation has no 0s and whose sum of digits is $sum > 2
def task($sum):
  # Input: array of digits
  def nozeros: select(all(.[]; . != 0));
  range(3;infinite;2)
  | select(digits | (.[-1] != 5 and nozeros and (add == $sum)) )
  | select(is_prime);

emit_until(. >= 5000;  task(25) )
