def enumerate(s): foreach s as $x (-1; .+1; [., $x]);

def fibonacci_words:
  "1",
  (["0","1"]
   | recurse([add, .[0]])
   | .[0]);

# Generate the first n terms of the Fibonacci word sequence
# as a stream of arrays of the form [index, word] starting with [0,1]
def fibonacci_words($n):
  enumerate(limit($n; fibonacci_words));

def task(n):
  fibonacci_words(n)
  | .[0] as $i
  | (.[1]|length) as $len
  | (.[1]|entropy) as $e
  | "\($i|rjustify(3)) \($len|rjustify(10))  \($e|precision(6))"
;

task(37)
