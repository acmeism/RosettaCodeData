# n is the number of decimal places of precision
def round(n):
  (if . < 0 then -1 else 1 end) as $s
  | $s*10*.*n | if (floor % 10) > 4 then (.+5) else . end | ./10 | floor/n | .*$s;

def abs: if . < 0 then -. else . end;

# Is the input an integer?
def integerq: ((. - ((.+.01) | floor)) | abs) < 0.01;
