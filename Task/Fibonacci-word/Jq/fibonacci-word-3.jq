# Generate the first n terms of the Fibonacci word sequence
# as a stream of arrays of the form [index, word]
def fibonacci_words(n):
  # input: [f(i-2), f(i-1), countdown, counter]
  def fib:
    if .[2] == 1 then [.[3], .[0]]
    else
      (.[1] + .[0]) as $sum
      | [ .[3], .[0]], ([ .[1], $sum, (.[2] - 1), (.[3] + 1) ] | fib)
    end;
  if n <= 0 then empty
  else (["1", "0", n, 1] | fib)
  end;

def task(n):
  fibonacci_words(n)
  | .[0] as $i
  | (.[1]|length) as $len
  | (.[1]|entropy) as $e
  | "\($i|rjustify(3)) \($len|rjustify(10))  \($e|precision(6))"
;

task(37)
