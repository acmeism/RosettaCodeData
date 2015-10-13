def fib(n, sequence=[1])
  return sequence.last if n == 0

  current_number, last_number = sequence.last(2)
  sequence << current_number + (last_number or 0)

  fib(n-1, sequence)
end
