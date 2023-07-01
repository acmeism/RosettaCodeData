def pp0(width):
  tostring
  | if width > length then (width - length) * "0" + . else . end;

# pp(left; right) formats a decimal number to occupy
# (left+right+1) positions if possible,
# where "left" is the number of characters to the left of
# the decimal point, and similarly for "right".
def pp(left; right):
  def lpad: if (left > length) then ((left - length) * "0") + . else . end;
  tostring as $s
  | $s
  | index(".") as $ix
  | ((if $ix then $s[0:$ix] else $s end) | lpad) + "." +
    (if $ix then $s[$ix+1:] | .[0:right] else "" end);
