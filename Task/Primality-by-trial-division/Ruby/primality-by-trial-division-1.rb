def prime(a)
  if a == 2
    true
  elsif a <= 1 || a % 2 == 0
    false
  else
    divisors = Enumerable::Enumerator.new(3..Math.sqrt(a), :step, 2)
    # this also creates an enumerable object:  divisors = (3..Math.sqrt(a)).step(2)
    !divisors.any? { |d| a % d == 0 }
  end
end
