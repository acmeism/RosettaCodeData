harmonics = Enumerator.new do |y|
  res = 0
  (1..).each {|n| y << res += Rational(1, n) }
end

n = 20
The first #{n} harmonics (as rationals):""
harmonics.take(n).each_slice(5){|slice| puts "%20s"*slice.size % slice }

puts
milestones = (1..10).to_a
harmonics.each.with_index(1) do |h,i|
  if h > milestones.first then
    puts "The first harmonic number > #{milestones.shift} is #{h.to_f} at position #{i}"
  end
  break if milestones.empty?
end
