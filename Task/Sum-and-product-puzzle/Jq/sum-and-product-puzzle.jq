# For readability:
def collect(c): map(select(c));

# stream-oriented checks:
def hasMoreThanOne(s): [limit(2;s)] | length > 1;

def hasOne(s): [limit(2;s)] | length == 1;

def prod: .[0] * .[1];

## A stream of admissible [x,y] values
def xy:
  [range(2;50) as $x  # 1 < X < Y < 100
   | range($x+1; 101-$x) as $y
   | [$x, $y] ] ;

# The stream of [x,y] pairs matching "S knows the sum is $sum"
def sumEq($sum): select( $sum == add );

# The stream of [x,y] pairs matching "P knows the product is $prod"
def prodEq($p): select( $p == prod );

## The solver:
def solve:
  xy as $s0

# S says P does not know:
  | $s0
  | collect(add as $sum
      | all( $s0[]|sumEq($sum);
             prod as $p
             | hasMoreThanOne($s0[] | prodEq($p)))) as $s1

# P says: Now I know:
  | $s1
  | collect(prod as $prod | hasOne( $s1[]|prodEq($prod)) ) as $s2

# S says: Now I also know
  | $s2[]
  | select(add as $sum | hasOne( $s2[] | sumEq($sum)) ) ;

solve
