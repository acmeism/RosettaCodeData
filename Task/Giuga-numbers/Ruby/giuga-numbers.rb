require 'prime'

giuga = (1..).lazy.select do |n|
  pd = n.prime_division
  pd.sum{|_, d| d} > 1 &&  #composite
  pd.all?{|f, _| (n/f - 1) % f == 0}
end

p giuga.take(4).to_a
