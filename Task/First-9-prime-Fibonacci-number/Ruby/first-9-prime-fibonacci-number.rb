require 'prime'

prime_fibs = Enumerator.new do |y|
  a, b = 1, 1
  loop do
    y << a if a.prime?
    a, b = b, a + b
  end
end
puts prime_fibs.take(9)
