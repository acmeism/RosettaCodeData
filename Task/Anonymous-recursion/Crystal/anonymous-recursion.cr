def fib (n : Int64)
  raise "only positive numbers allowed" if n < 0
  # it needs to be declared beforehand to be able to call it
  # from inside itself
  fib1 = uninitialized Int64 -> Int64
  fib1 = -> (n : Int64) {
    if n < 2
      n
    else
      fib1[n - 1] + fib1[n - 2]
    end
  }
  fib1[n]
end
