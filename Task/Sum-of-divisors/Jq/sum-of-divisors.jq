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

def add(s): reduce s as $x (null; .+$x);

def sum_of_divisors: add(divisors);

# For pretty-printing
def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# The task:
[range(1; 101) | sum_of_divisors] | nwise(10) | map(lpad(4)) | join("")
