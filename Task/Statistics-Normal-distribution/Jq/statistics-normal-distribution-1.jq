# Pretty print a number to facilitate alignment of the decimal point.
# Input: a number without an exponent
# Output: a string holding the reformatted number so that there are at least `left` characters
# to the left of the decimal point, and exactly `right` characters to its right.
# Spaces are used for padding on the left, and zeros for padding on the right.
# No left-truncation occurs, so `left` can be specified as 0 to prevent left-padding.
def pp(left; right):
  def lpad: tostring | (left - length) as $l | (" " * $l)[:$l] + .;
  def rpad:
    if (right > length) then . + ((right - length) * "0")
    else .[:right]
    end;
  tostring as $s
  | $s
  | index(".") as $ix
    | ((if $ix then $s[0:$ix] else $s end) | lpad) + "." +
       (if $ix then $s[$ix+1:] | .[:right] else "" end | rpad) ;

def sigma( stream ): reduce stream as $x (0; . + $x);

# Input: {n, sum, ss}
# Output: augmented object with {mean, variance}
def sample_mean_and_variance:
  .mean = (.sum/.n)
  | .variance = ((.ss / .n) - .mean*.mean);
