def epsilon
  eps = 1.0_f32
  while 1.0_f32 + eps != 1.0_f32
    eps /= 2.0_f32
  end

  eps
end

def kahan(nums)
  sum = 0.0_f32
  c = 0.0_f32
  nums.each do |num|
    y = num - c
    t = sum + y
    c = (t - sum) - y
    sum = t
  end

  sum
end

a = 1.0_f32
b = epsilon
c = -b

puts "Epsilon    = #{b}"
puts "Sum        = #{a + b + c}"
puts "Kahan sum  = #{kahan([a, b, c])}"
