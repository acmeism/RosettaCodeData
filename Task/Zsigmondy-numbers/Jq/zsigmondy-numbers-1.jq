# Input: an integer
def isPrime:
  . as $n
  | if   ($n < 2)       then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    else 5
    | until( . <= 0;
        if .*. > $n then -1
	elif ($n % . == 0) then 0
        else . + 2
        |  if ($n % . == 0) then 0
           else . + 4
           end
        end)
    | . == -1
    end;

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

def gcd(a; b):
  # subfunction expects [a,b] as input
  # i.e. a ~ .[0] and b ~ .[1]
  def rgcd: if .[1] == 0 then .[0]
         else [.[1], .[0] % .[1]] | rgcd
         end;
  [a,b] | rgcd;

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);
