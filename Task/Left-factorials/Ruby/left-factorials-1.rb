left_fact = Enumerator.new do |y|
  f, lf = 1, 0
  1.step do |n|
    y  << lf #yield left_factorial
    lf += f
    f  *= n
  end
end
