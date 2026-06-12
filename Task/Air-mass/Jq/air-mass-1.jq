def pi: 4 * (1|atan);

def radians: . * pi / 180;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Input: a number
# Output: a string with $digits fractional decimal digits, with proper rounding
def fmt($width; $digits):
  . as $in
  | tostring
  | index(".") as $ix
  | if test("[eE]") then .
    elif $ix
    then pow(10; $digits) as $p
    | ($in * $p | round | tostring) as $s
    | if test("[eE]") then $s
      else ($s | index(".")) as $ix
      | if $ix then $s[:$ix + 1] + $s[$ix+1: $ix+1+$digits]
        else $s[:-$digits] + "." + $s[-$digits:]
        end
      end
    else . + "." + "0" * digits
    end
  | lpad($width);
