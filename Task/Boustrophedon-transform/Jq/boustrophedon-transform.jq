### Generic functions

# The stream of Fibonacci numbers beginning with 1, 1, 2, ...
def fibs:
  def f: [0,1] | recurse( [.[1], add] );
  f | .[1];

# The stream of factorials beginning with 1, 1, 2, 6, 24, ...
def factorials:
  def f: recurse( [.[0] + 1, .[0] * .[1]] );
  [1, 1] | f | .[1];

# An array of length specified by .
def array($value): [range(0; .) | $value];

# Give a glimpse of the (very large) input number
def glimpse:
  tostring
  | "\(.[:20]) ... \(.[-20:]) \(length) digits";

### The Boustrophedon transform
def boustrophedon($a):
  ($a|length) as $k
  | ($k | array(0)) as $list
  | {b: $list,
     cache: [] }

  # input: {cache}, output: {result, cache}
  | def T($k; $n):
      if $n == 0 then .result = $a[$k]
      else .cache[$k][$n] as $kn
      | if $kn > 0 then .result = $kn
        else T($k; $n-1)
        | .result as $r
        | T($k-1; $k-$n)
        | .result = $r + .result
        | .cache[$k][$n] = .result
        end
      end;
  .b[0] = $a[0]
  | reduce range(1; $k) as $n (.; T($n; $n) | .b[$n] = .result )
  | .b;

### Exercises

"1 followed by 0's:",
  boustrophedon( [1] + (14 | array(0)) ),

"\nAll 1's:",
  boustrophedon(15|array(1)),

"\nAlternating 1, -1",
  boustrophedon( [range(0;7) | 1, -1] + [1] ),

"\nPrimes:",
  boustrophedon([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]),

"\nFibonacci numbers:",
  boustrophedon([limit(15; fibs)]),

"\nFactorials:",
  boustrophedon([limit(15; factorials)]),

## Stretch tasks require gojq
"\nGlimpse of 1000th element for the Fibonaccis",
(boustrophedon([limit(1000; fibs)]) | .[999] | glimpse),

"\nGlimpse of 1000th element for the factorials:",
(boustrophedon([limit(1000; factorials)]) | .[999] | glimpse)
