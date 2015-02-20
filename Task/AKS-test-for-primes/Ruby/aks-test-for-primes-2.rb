def x_minus_1_to_the(p)
  p.times.inject([1]) do |ex, _|
    ([0] + ex).zip(ex + [0]).map { |x,y| x - y }
  end
end

def prime?(p)
  return false if p < 2
  coeff = x_minus_1_to_the(p)
  coeff[0] += coeff.pop
  coeff.all?{|n| n%p==0}
end

8.times do |n|
  puts "(x-1)^#{n} = " +
  x_minus_1_to_the(n).
  each_with_index.
  map { |c, p|
    if p.zero? then c.to_s
    else
      (c<0 ? " - " : " + ") + (c.abs==1 ? "x" : "#{c.abs}x") + (p==1 ? "" : "^#{p}")
    end
  }.join
end

puts "\nPrimes below 50:", 50.times.select {|n| prime? n}.join(',')
