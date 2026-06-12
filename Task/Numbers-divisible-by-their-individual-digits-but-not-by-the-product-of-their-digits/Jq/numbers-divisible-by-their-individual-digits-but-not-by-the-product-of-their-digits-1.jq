def digits:
  tostring | explode | map( [.] | implode | tonumber);

def prod:
  reduce .[] as $i (1; .*$i);

def is_divisible_by_digits_but_not_product:
  . as $n
  | tostring
  | select( null == index("0"))
  | digits
  | all( unique[]; $n % . == 0)
    and ($n % prod != 0);
