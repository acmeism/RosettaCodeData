# Generator
def fibonacci(n):
  # input: [f(i-2), f(i-1), countdown]
  def fib: (.[0] + .[1]) as $sum
           | if .[2] == 0 then $sum
             else $sum, ([ .[1], $sum, .[2] - 1 ] | fib)
             end;
  [-1, 1, n] | fib;
