require 'prime'

def μ(n)
  pd = n.prime_division
  return 0 unless pd.map(&:last).all?(1)
  pd.size.even? ? 1 : -1
end

(["  "] + (1..199).map{|n|"%2s" % μ(n)}).each_slice(20){|line| puts line.join(" ") }
