R = Enumerator.new do |y|
  y << n = 1
  S.each{|s_val| y << n += s_val}
end

S = Enumerator.new do |y|
  y << 2
  y << 4
  u = 5
  R.each do |r_val|
    next if u > r_val
    (u...r_val).each{|r| y << r}
    u = r_val+1
  end
end

p R.take(10)
p S.take(10)
p (R.take(40)+ S.take(960)).sort == (1..1000).to_a
