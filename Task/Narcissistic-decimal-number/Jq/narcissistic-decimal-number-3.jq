# Input: [n, [i, [0^i, 1^i, 2^i,...]]] where i is the number of digits in n.
def is_narcissistic:
  def digits: tostring | explode[] | [.] | implode | tonumber;
  .[1][1] as $powers
  | .[0]
  | if . < 0 then false
    else . == reduce digits as $d (0;  . + $powers[$d] )
    end;
