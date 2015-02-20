bernoulli = Enumerator.new do |y|
  ar, m = [], 0
  loop do
    ar << Rational(1, m+1)
    m.downto(1){|j| ar[j-1] = j*(ar[j-1] - ar[j]) }
    y << ar.first  # yield
    m += 1
  end
end

b_nums = bernoulli.take(61)
width  = b_nums.map{|b| b.numerator.to_s.size}.max
b_nums.each_with_index {|b,i| puts "B(%2i) = %*i/%i" % [i, width, b.numerator, b.denominator] unless b.zero? }
