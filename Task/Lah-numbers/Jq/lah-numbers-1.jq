## Generic functions

def factorial: reduce range(2;.+1) as $i (1; . * $i);

# nCk assuming n >= k
def binomial($n; $k):
  if $k > $n / 2 then binomial($n; $n-$k)
  else (reduce range($k+1; $n+1) as $i (1; . * $i)) as $numerator
  | reduce range(1;1+$n-$k) as $i ($numerator; . / $i)
  end;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def max(s): reduce s as $x (-infinite; if $x > . then $x else . end);

def lah($n; $k; $signed):
    if $n == $k then 1
    elif $n == 0 or $k == 0 or $k > $n then 0
    elif $k == 1 then $n|factorial
    else
       (binomial($n; $k) * binomial($n - 1; $k - 1) * (($n - $k)|factorial)) as $unsignedvalue
        | if $signed and ($n % 1 == 1)
          then -$unsignedvalue
          else $unsignedvalue
          end
    end;

def lah($n; $k): lah($n;$k;false);
