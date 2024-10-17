require "big"

def bernoulli(n)
    ar = [] of BigRational
    (0..n).each do |m|
        ar << BigRational.new(1, m+1)
        m.downto(1) { |j| ar[j-1] = j * (ar[j-1] - ar[j]) }
    end
    ar[0] # (which is Bn)
end

b_nums = (0..61).map { |i| bernoulli(i) }
width  = b_nums.map{ |b| b.numerator.to_s.size }.max
b_nums.each_with_index { |b,i| puts "B(%2i) = %*i/%i" % [i, width, b.numerator, b.denominator] unless b.zero? }
