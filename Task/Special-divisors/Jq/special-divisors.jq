# divisors as an unsorted stream
def divisors:
  if . == 1 then 1
  else . as $n
  | label $out
  | range(1; $n) as $i
  | ($i * $i) as $i2
  | if $i2 > $n then break $out
    else if $i2 == $n then $i
         elif ($n % $i) == 0 then $i, ($n/$i)
         else empty
	 end
    end
  end;

def is_special_divisor:
  def reverse_number: tostring|explode|reverse|implode|tonumber;
  reverse_number as $nreverse
  | all(divisors; $nreverse % reverse_number == 0);

range(1;200) | select(is_special_divisor)
