# Compute the number of divisors, without calling sqrt
def ndivisors:
  def sum(s): reduce s as $x (null; .+$x);
  if . == 1 then 1
  else . as $n
  | sum( label $out
         | range(1; $n) as $i
         | ($i * $i) as $i2
         | if $i2 > $n then break $out
           else if $i2 == $n
                then 1
                elif ($n % $i) == 0
                then 2
                else empty
                end
           end)
  end;

# Emit the antiprimes as a stream
def antiprimes:
  1,
  foreach range(2; infinite; 2) as $i ({maxfactors: 1};
    .emit = null
    | ($i | ndivisors) as $nfactors
    | if $nfactors > .maxfactors
      then .emit = $i
      | .maxfactors = $nfactors
      else .
      end;
      select(.emit).emit);

"The first 20 anti-primes are:", limit(20; antiprimes)
