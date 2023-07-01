def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# print as dollars and cents
def dollars:
  (. % 100) as $c
  | "$\((. - $c) /100).\($c)";

def dollars($width):
  dollars | lpad($width);

def innerproduct($y):
  . as $x
  | reduce range(0;$x|length) as $i (0; . + ($x[$i]*$y[$i]));

def plus($y):
  . as $x
  | reduce range(0;$x|length) as $i ([]; .[$i] = ($x[$i]+$y[$i]));

# Round up or down
def integer_division($y):
  (. % $y) as $remainder
  | (. - $remainder) / $y
  | if $remainder * 2 > $y then . + 1 else . end;

# For computing taxes
def precision: 10000;
def cents: integer_division(precision);


### The task:

def p: [550, 286];
def q: [4000000000000000, 2];

def taxrate: 765;  # relative to `precision`

(p | innerproduct(q))         as $before_tax     # cents
| ($before_tax * taxrate)     as $taxes          # relative to precision
| ((($before_tax * precision) + $taxes) | cents) as $after_tax # cents
| ($after_tax|tostring|length + 2) as $width
|
  " Total before tax: \($before_tax    | dollars($width))",
  " -            tax: \($taxes | cents | dollars($width))",
  " Total after  tax: \($after_tax     | dollars($width))"
