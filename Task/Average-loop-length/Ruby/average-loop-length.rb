class Integer
  def factorial
    self == 0 ? 1 : (1..self).inject(:*)
  end
end

def rand_until_rep(n)
  rands = {}
  loop do r = rand(1..n)
    return rands.size if rands[r]
    rands[r] = true
  end
end

runs = 1_000_000

puts " n\tavg\texp.\tdiff\n_____________________________"
(1..20).each do |n|
  sum_of_runs = runs.times.inject(0){|sum, _| sum += rand_until_rep(n)}
  avg = sum_of_runs / runs.to_f
  analytical = (1..n).inject(0){|sum, i| sum += (n.factorial / (n**i).to_f / (n-i).factorial)}
  puts "%2d %8.4f %8.4f %8.4f" % [n, avg, analytical, (avg/analytical - 1)*100]
end
