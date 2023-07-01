def nth_fib(n):
  # input: [f(i-2), f(i-1), countdown]
  def fib: (.[0] + .[1]) as $sum
    | .[2] as $n
    | if ($n <= 0) then $sum
      else [ .[1], $sum, $n - 1 ]
    | fib end;
  [-1, 1, n] | fib;
