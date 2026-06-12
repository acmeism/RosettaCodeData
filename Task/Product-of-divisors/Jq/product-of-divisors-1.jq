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

def product(s): reduce s as $x (1; . * $x);

def product_of_divisors: product(divisors);

# For pretty-printing
def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
