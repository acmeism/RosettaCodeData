fib = Enumerator.new do |y|
  f0, f1 = 0, 1
  loop do
    y <<  f0
    f0, f1 = f1, f0 + f1
  end
end
