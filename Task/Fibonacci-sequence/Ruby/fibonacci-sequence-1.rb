def fibIter(n)
  return 0 if n == 0
  fibPrev, fib = 1, 1
  (n.abs - 2).times { fibPrev, fib = fib, fib + fibPrev }
  fib * (n<0 ? (-1)**(n+1) : 1)
end
