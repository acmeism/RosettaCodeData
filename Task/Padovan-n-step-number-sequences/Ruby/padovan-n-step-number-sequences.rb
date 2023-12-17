def padovan(n_step)
  return to_enum(__method__, n_step) unless block_given?
  ar = [1, 1, 1]
  loop do
    yield sum = ar[..-2].sum
    ar.shift if ar.size > n_step
    ar << sum
  end
end

t = 15
(2..8).each do |n|
  print "N=#{n} :"
  puts "%5d"*t % padovan(n).take(t)
end
