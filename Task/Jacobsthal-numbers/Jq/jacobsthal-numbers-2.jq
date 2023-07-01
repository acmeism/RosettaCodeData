def jacobsthal:
  . as $n
  | ( (2|power($n)) - (if ($n%2 == 0) then 1 else -1 end)) | divmod(3)[0];

def jacobsthalLucas:
  . as $n
  | (2|power($n)) + (if ($n%2 == 0) then 1 else -1 end);

def tasks:
  def pp($width): chunks(5) | map(lpad($width)) | join("");

  [range(0;30) | jacobsthal] as $js
  | "First 30 Jacobsthal numbers:",
    ( $js | pp(12)),

    "\nFirst 30 Jacobsthal-Lucas numbers:",
    ( [range(0;30) | jacobsthalLucas]  | pp(12)),

    "\nFirst 20 Jacobsthal oblong numbers:",
    ( [range(0;20) | $js[.] * $js[1+.]] | pp(14)),

   "\nFirst 11 Jacobsthal primes:",
    limit(11; range(0; infinite) | jacobsthal | select(is_prime))
;

tasks
