# def negate:
# def lessOrEqual(x; y): # x <= y
# def long_add(x;y):     # x+y
# def long_minus(x;y):   # x-y
# def long_multiply(x;y) # x*y
# def long_divide(x;y):  # x/y => [q,r]
# def long_div(x;y)      # integer division
# def long_mod(x;y)      # %

# In all cases, x and y must be strings

def negate: (- tonumber) | tostring;

def lessOrEqual(num1; num2): (num1|tonumber) <= (num2|tonumber);

def long_add(num1; num2): ((num1|tonumber) + (num2|tonumber)) | tostring;

def long_minus(x;y): ((num1|tonumber) - (num2|tonumber)) | tostring;

# multiply two decimal strings, which may be signed (+ or -)
def long_multiply(num1; num2):
  ((num1|tonumber) * (num2|tonumber)) | tostring;

# return [quotient, remainder]
# 0/0 = 1; n/0 => error
def long_divide(xx;yy):  # x/y => [q,r] imples x == (y * q) + r
  def ld(x;y):
    def abs: if . < 0 then -. else . end;
    (x|abs) as $x | (y|abs) as $y
    | (if (x >= 0 and y > 0) or (x < 0 and y < 0) then 1 else -1 end) as $sign
    | (if x >= 0 then 1 else -1 end) as $sx
    | [$sign * ($x / $y | floor), $sx * ($x % $y)];
  ld( xx|tonumber; yy|tonumber) | map(tostring);

def long_div(x;y):
  long_divide(x;y) | .[0];

def long_mod(x;y):
  ((x|tonumber) % (y|tonumber)) | tostring;
