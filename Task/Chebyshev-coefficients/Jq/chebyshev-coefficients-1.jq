def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;
def rpad($len; $fill): tostring | ($len - length) as $l | . + ($fill * $l)[:$l];

# Format a decimal number so that there are at least `left` characters
# to the left of the decimal point, and at most `right` characters to its right.
# No left-truncation occurs, so `left` can be specified as 0 to prevent left-padding.
# If tostring has an "e" then eparse as defined below is used.
def pp(left; right):
  def lpad: if (left > length) then ((left - length) * " ") + . else . end;
  def eparse: index("e") as $ix | (.[:$ix]|pp(left;right)) + .[$ix:];
  tostring as $s
  | $s
  | if test("e") then eparse
    else index(".") as $ix
    | ((if $ix then $s[0:$ix] else $s end) | lpad) + "." +
      (if $ix then $s[$ix+1:] | .[0:right] else "" end)
    end;
