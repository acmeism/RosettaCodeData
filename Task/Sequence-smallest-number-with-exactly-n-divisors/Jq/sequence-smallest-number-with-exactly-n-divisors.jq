# divisors as an unsorted stream (without calling sqrt)
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

def count(s): reduce s as $x (0; .+1);

# smallest number with exactly n divisors
def A005179:
  . as $n
  | first( range(1; infinite) | select( count(divisors) == $n ));

# The task:
"The first 15 terms of the sequence are:",
[range(1; 16) | A005179]
