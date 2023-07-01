# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($in;$b): reduce range(0;$b) as $i (1; . * $in);

# $n is assumed to be a non-negative integer
def is_disarium:
  . as $n
  | {$n, sum: 0, len: (tostring|length) }
  | until (.n == 0;
      .sum += power(.n % 10; .len)
      | .n = (.n/10 | floor)
      | .len -= 1 )
  | .sum == $n ;

# Emit a stream ...
def disariums:
  range(0; infinite) | select(is_disarium);

limit(19; disariums)
