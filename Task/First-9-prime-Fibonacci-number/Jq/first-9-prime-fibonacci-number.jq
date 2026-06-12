# Emit an unbounded stream of Fibonacci numbers
def fibonaccis:
  # input: [f(i-2), f(i-1)]
  def fib: (.[0] + .[1]) as $sum
           | if .[2] == 0 then $sum
             else $sum, ([ .[1], $sum ] | fib)
             end;
  [-1, 1] | fib;

"The first 9 prime Fibonacci numbers are:",
limit(9; fibonaccis | select(is_prime))
