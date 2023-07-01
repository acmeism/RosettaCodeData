def fermat:
  . as $n
  | (2 | power( 2 | power($n))) + 1;

# https://en.wikipedia.org/wiki/Pollard%27s_rho_algorithm
def pollardRho($x):
  . as $n
  | def g: (.*. + 1) % $n ;
  {x:$x, y:$x, d:1}
  | until(.d != 1;
         .x |= g
       | .y |= (g|g)
       | .d = gcd((.x - .y)|length; $n) )
  | if .d == $n then 0
    else .d
    end ;

def rhoPrimeFactors:
  . as $n
  | pollardRho(2)
  | if . == 0
    then [$n, 1]
    else [., ($n / .)]
    end ;

"The first 10 Fermat numbers are:",
 [ range(0;10) | fermat ] as $fns
 | (range(0;10) | "F\(.) is \($fns[.])"),

   ("\nFactors of the first 7 Fermat numbers:",
    range(0;7) as $i
    | $fns[$i]
    | rhoPrimeFactors as $factors
    | if $factors[1] == 1
      then "F\($i) : rho-prime", " ... => \(if is_prime then "prime" else "not" end)"
      else "F\($i) => \($factors)"
      end )
