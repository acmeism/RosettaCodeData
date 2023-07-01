require "prime"

motzkin = Enumerator.new do |y|
  m = [1,1]
  m.each{|m| y << m }

  2.step do |i|
    m << (m.last*(2*i+1) + m[-2]*(3*i-3)) / (i+2)
    m.unshift # an arr with last 2 elements is sufficient
    y << m.last
  end
end

motzkin.take(42).each_with_index do |m, i|
  puts "#{'%2d' % i}: #{m}#{m.prime? ? ' prime' : ''}"
end
