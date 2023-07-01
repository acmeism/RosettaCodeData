def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Simplistic approach:
def round($ndec): pow(10;$ndec) as $p | . * $p | round / $p;

# Emit {mean, ssdev, std} where std is (ssdev/length|sqrt)
def basic_statistics:
  . as $in
  | length as $length
  | (add / $length) as $mean
  | { $mean,
      ssdev: (reduce $in[] as $x (0; . + (($x - $mean) | .*.))) }
  | .std = ((.ssdev / $length ) | sqrt);
