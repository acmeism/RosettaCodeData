# Generate the first n Fibonacci numbers: 1, 1, ...
# Numerical accuracy is insufficient beyond about 1450.
def fibonacci(n):
  # input: [f(i-2), f(i-1), countdown]
  def fib: (.[0] + .[1]) as $sum
           | if .[2] <= 0 then empty
             elif .[2] == 1 then $sum
             else $sum, ([ .[1], $sum, .[2] - 1 ] | fib)
             end;
  [1, 0, n] | fib ;

# is_prime is tailored to work with jq 1.4
def is_prime:
  if . == 2 then true
  else 2 < . and . % 2 == 1 and
       . as $in
       | (($in + 1) | sqrt) as $m
       | (((($m - 1) / 2) | floor) + 1) as $max
       | reduce range(1; $max) as $i
           (true; if . then ($in % ((2 * $i) + 1)) > 0 else false end)
  end ;

# primes in [m,n)
def primes(m;n):
  range(m;n) | select(is_prime);

def runs:
  reduce .[] as $item
    ( [];
      if . == [] then [ [ $item, 1] ]
      else  .[length-1] as $last
            | if $last[0] == $item
              then (.[0:length-1] + [ [$item, $last[1] + 1] ] )
              else . + [[$item, 1]]
              end
      end ) ;

# Inefficient but brief:
def histogram: sort | runs;

def benford_probability:
  tonumber
  | if . > 0 then ((1 + (1 /.)) | log) / (10|log)
    else 0
    end ;

# benford takes a stream and produces an array of [ "d", observed, expected ]
def benford(stream):
  [stream | tostring | .[0:1] ] | histogram as $histogram
  | reduce ($histogram | .[] | .[0]) as $digit
      ([]; . + [$digit, ($digit|benford_probability)] )
  | map(select(type == "number")) as $probabilities
  | ([ $histogram | .[] | .[1] ] | add) as $total
  | reduce range(0; $histogram|length) as $i
      ([]; . + ([$histogram[$i] + [$total * $probabilities[$i]] ] ) ) ;

# given an array of [value, observed, expected] values,
# produce the χ² statistic
def chiSquared:
  reduce .[] as $triple
    (0;
     if $triple[2] == 0 then .
     else . + ($triple[1] as $o | $triple[2] as $e | ($o - $e) | (.*.)/$e)
     end) ;

# truncate n places after the decimal point;
# return a string since it can readily be converted back to a number
def precision(n):
  tostring as $s | $s | index(".")
  | if . then $s[0:.+n+1] else $s end ;

# Right-justify but do not truncate
def rjustify(n):
  length as $length | if n <= $length then . else " " * (n-$length) + . end;

# Attempt to align decimals so integer part is in a field of width n
def align(n):
  index(".") as $ix
  | if n < $ix then .
    elif $ix then (.[0:$ix]|rjustify(n)) +.[$ix:]
    else rjustify(n)
    end ;

# given an array of [value, observed, expected] values,
# produce rows of the form: value observed expected
def print_rows(prec):
  .[] | map( precision(prec)|align(5) + "  ") | add ;

def report(heading; stream):
    benford(stream) as $array
    | heading,
      " Digit Observed Expected",
      ( $array | print_rows(2) ),
      "",
      " χ² = \( $array | chiSquared | precision(4))",
      ""
;

def task:
  report("First 100 fibonacci numbers:"; fibonacci( 100) ),
  report("First 1000 fibonacci numbers:"; fibonacci(1000) ),
  report("Primes less than 1000:"; primes(2;1000)),
  report("Primes between 1000 and 10000:"; primes(1000;10000)),
  report("Primes less than 100000:"; primes(2;100000))
;

task
