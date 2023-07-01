### Formatting

# Right-justify but do not truncate
def rjustify(n):
  tostring | length as $length | if n <= $length then . else " " * (n-$length) + . end;

# Attempt to align decimals so integer part is in a field of width n
def align($n):
  tostring
  | index(".") as $ix
  | if $ix
    then if $n < $ix then .
         elif $ix then (.[0:$ix]|rjustify($n)) +.[$ix:]
         else rjustify($n)
         end
    else . + ".0" | align($n)
    end ;

# number of decimal places ($n>=0)
def fround($n):
  pow(10;$n) as $p
  | (. * $p | round ) / $p
  | tostring
  | index(".") as $ix
  | ("0" * $n) as $zeros
  | if $ix then . + $zeros | .[0 : $ix + $n + 1]
    else . + "." + $zeros
    end;

def hide_trailing_zeros:
  tostring
  | (capture("(?<x>[^.]*[.].)(?<y>00*$)") // null) as $capture
  | if $capture
    then $capture | (.x + (.y|gsub("0"; " ")))
    else .
    end;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
