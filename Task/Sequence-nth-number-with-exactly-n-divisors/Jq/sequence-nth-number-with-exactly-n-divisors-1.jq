def count(stream): reduce stream as $i (0; .+1);

# To maintain precision:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

def primes: 2, (range(3; infinite; 2) | select(is_prime));

# divisors as an unsorted stream
def divisors:
  if . == 1 then 1
  else . as $n
  | label $out
  | range(1; $n) as $i
  | ($i * $i) as $i2
  | if $i2 > $n then break $out
    else if $i2 == $n
         then $i
         elif ($n % $i) == 0
         then $i, ($n/$i)
         else empty
         end
    end
  end;
