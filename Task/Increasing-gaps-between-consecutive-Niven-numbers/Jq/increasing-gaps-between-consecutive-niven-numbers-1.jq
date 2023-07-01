def add(s): reduce s as $x (null; . + $x);

def digit_sum:
  def digits: tostring | explode[] | [.] | implode | tonumber;
  add(digits);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
