def tobern2 (a0, a1, a2)
  { a0,
    a0 + 0.5*a1,
    a0 + a1 + a2
  }
end

def evalbern2 (b0, b1, b2, t)
  s = 1 - t
  b01 = s*b0 + t*b1
  b12 = s*b1 + t*b2

  s*b01 + t*b12
end

def tobern3 (a0, a1, a2, a3)
  { a0,
    a0 + (1/3)*a1,
    a0 + (2/3)*a1 + (1/3)*a2,
    a0 + a1 + a2 + a3
  }
end

def evalbern3 (b0, b1, b2, b3, t)
  s = 1 - t
  b01 = s*b0 + t*b1
  b12 = s*b1 + t*b2
  b23 = s*b2 + t*b3
  b012 = s*b01 + t*b12
  b123 = s*b12 + t*b23

  s*b012 + t*b123
end

def bern2to3 (q0, q1, q2)
  { q0,
    (1/3)*q0 + (2/3)*q1,
    (2/3)*q1 + (1/3)*q2,
    q2
  }
end

mp  = { 1.0, 0.0, 0.0 }
b2p  = tobern2 *mp

mq  = { 1.0, 2.0, 3.0 }
b2q  = tobern2 *mq

[{mp, b2p}, {mq, b2q}].each do |m, b|
  puts "mono #{m} --> bern #{b}"
end

[{"p", b2p}, {"q", b2q}].each do |n, b|
  [0.25, 7.5].each do |x|
    puts "#{n}(#{x}) = #{ evalbern2(*b, x) }"
  end
end
puts

mp  = { *mp, 0.0 }
b3p = tobern3 *mp

mq  = { *mq, 0.0 }
b3q = tobern3 *mq

mr  = { 1.0, 2.0, 3.0, 4.0 }
b3r = tobern3 *mr

[{mp, b3p}, {mq, b3q}, {mr, b3r}].each do |m, b|
  puts "mono #{m} --> bern #{b}"
end

[{"p", b3p}, {"q", b3q}, {"r", b3r}].each do |n, b|
  [0.25, 7.5].each do |x|
    puts "#{n}(#{x}) = #{ evalbern3(*b, x) }"
  end
end
puts

[b2p, b2q].each do |b|
  puts "bern #{b} --> bern #{ bern2to3(*b) }"
end
