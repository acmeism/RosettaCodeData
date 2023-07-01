def task:
  def task1($n):
    range(1;$n)
    | totient as $totient
    | {i: ., $totient, isprime: ($totient == ( . - 1 ))};

  task1(26);

def onepass:
  reduce (10000 | primes_via_totient) as $p ({};
      if $p < 10000
      then .["10^4"] += 1
      | if $p < 1000
        then .["10^3"] += 1
        | if $p < 100
          then .["10^2"] += 1
          else . end else . end else . end) ;

task, "\nCounts of primes up to the given limits:", onepass
