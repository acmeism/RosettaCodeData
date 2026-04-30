a = 1.0
b = Math.sqrt(0.5)
t = 0.25
n = 1.0
prev_pi = 0.0

loop do
  prev_a = a
  a = (a + b) / 2
  b = Math.sqrt(prev_a * b)
  t -= n * (a - prev_a)**2
  n *= 2
  pi = (a + b)**2 / (t * 4)
  puts pi
  break if (prev_pi - pi).abs <= Float64::EPSILON
  prev_pi = pi
end
