def emit_until(cond; stream): label $out | stream | if cond then break $out else . end;

# For 0 <= $n <= ., factorials[$n] is $n !
def factorials:
   reduce range(1; .+1) as $n ([1];
    .[$n] = $n * .[$n-1]);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def primes: 2, (range(3; infinite; 2) | select(is_prime));
