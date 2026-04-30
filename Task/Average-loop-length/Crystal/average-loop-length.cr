struct Int
  def factorial
    raise "only positive" if self < 0
    (1_i64..self.to_i64).product
  end
end

def rand_until_rep (n)
  rands = {} of Int32 => Bool
  loop do
    r = rand(1..n)
    return rands.size if rands[r]?
    rands[r] = true
  end
end

runs = 1_000_000

puts " N    average    exp.        diff   ",
     "===  ========  ========  ==========="
(1..20).each do |n|
  sum_of_runs = runs.times.sum(0_i64) { rand_until_rep(n) }
  avg = sum_of_runs / runs
  analytical = (1..n).sum(0.0) {|i| (n.factorial / (n.to_f**i) / (n-i).factorial) }
  puts "%3d  %8.4f  %8.4f  (%8.4f%%)" % {n, avg, analytical, (avg/analytical - 1)*100}
end
