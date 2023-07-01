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

def is_perfect:
  requal(2; [divisors | r(1;. )] | radd);

# Example:
range(1;pow(2;19)) | select( is_perfect )
