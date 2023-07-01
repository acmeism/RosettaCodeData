# Input: the limit
def wieferich:
  primes[]
  | . as $p
  | select( ( (2|power($p-1)) - 1) % (.*.) == 0);

5000 | wieferich
