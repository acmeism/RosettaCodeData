# Is the input integer a Kaprekar integer?
def is_kaprekar:
    # The helper function acts like a loop:
    # input is [n, number, str]
    # where n is the position to be considered next,
    # number is the integer under consideration,
    # and str is the string representing number*number
    def _try:
      .[0] as $n | .[1] as $number | .[2] as $str
      | if $n >= ($str|length) then null
        else   ($str[0:$n] | tonumber) as $left
             | ($str[$n:]  | tonumber) as $right
             | if $left > $number then null
               elif $right == 0 then null
               elif ($left + $right) == $number then $n
               else [($n + 1), $number, $str] | _try
               end
        end;
    . as $in
    | if . == 1 then true
      elif . < 1 then false
      else null != ([1, $in, ($in*$in|tostring)] | _try)
      end ;

# Useful for counting how many times the condition is satisfied:
def count(generator; condition):
  reduce generator as $i (0; if ($i|condition ) then .+1 else . end);

def task:
  [ range(1;10000) | select( is_kaprekar ) ],
  count( range(1;1000000); is_kaprekar )
;
