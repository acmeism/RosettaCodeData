disariums = Enumerator.new do |y|
  (0..).each do |n|
    i = 0
    y << n if n.digits.reverse.sum{|d| d ** (i+=1) } == n
  end
end

puts disariums.take(19).to_a.join(" ")
