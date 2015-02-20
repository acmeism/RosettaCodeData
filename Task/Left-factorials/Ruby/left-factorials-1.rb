left_fact = Enumerator.new do |y|
  n, f, lf = 0, 1, 0
  loop do
    y  << lf #yield left_factorial
    n  += 1
    lf += f
    f  *= n
  end
end
