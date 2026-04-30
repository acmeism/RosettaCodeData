def division_by_zero? (dividend, divisor)
  dividend % divisor
  false
rescue DivisionByZeroError
  true
end
