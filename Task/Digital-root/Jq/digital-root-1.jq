def do_until(condition; next):
  def u: if condition then . else (next|u) end;
  u;

# n may be a decimal number or a string representing a decimal number
def digital_root(n):
  # string-only version
  def dr:
    # state: [mdr, persist]
    do_until( .[0] | length == 1;
              [ (.[0] | explode | map(.-48) | add | tostring), .[1] + 1 ]
              );
  [n|tostring, 0] | dr | .[0] |= tonumber;

def neatly:
  . as $in
  | range(0;length)
  | "\(.): \($in[.])";

def rjust(n): tostring | (n-length)*" " + .;
