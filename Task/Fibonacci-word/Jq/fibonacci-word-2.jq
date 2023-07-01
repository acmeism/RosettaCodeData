# truncate n places after the decimal point;
# return a string since it can readily be converted back to a number
def precision(n):
  tostring as $s | $s | index(".")
  | if . then $s[0:.+n+1] else $s end ;

# Right-justify but do not truncate
def rjustify(n):
  tostring | length as $length
  | if n <= $length then . else " " * (n-$length) + . end;

# Attempt to align decimals so integer part is in a field of width n
def align(n):
  tostring | index(".") as $ix
  | if n < $ix then .
    elif $ix then (.[0:$ix]|rjustify(n)) +.[$ix:]
    else rjustify(n)
    end ;
