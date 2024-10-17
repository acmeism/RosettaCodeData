require "big"

def bernoulli2(limit)
    ar = [] of BigRational
    (0..limit).each do |m|
      ar << BigRational.new(1, m+1)
      m.downto(1) { |j| ar[j-1] = j * (ar[j-1] - ar[j]) }
      yield ar[0] # use Bn value in required block
    end
end

b_nums = [] of BigRational
bernoulli2(61){ |b| b_nums << b }
width  = b_nums.map{ |b| b.numerator.to_s.size }.max
b_nums.each_with_index { |b,i| puts "B(%2i) = %*i/%i" % [i, width, b.numerator, b.denominator] unless b.zero? }
