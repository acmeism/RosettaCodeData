require 'prime'

def μ(n)
  return 1 if self == 1
  pd = n.prime_division
  return 0 unless pd.map(&:last).all?(1)
  pd.size.even? ? 1 : -1
end

def M(n)
  (1..n).sum{|n| μ(n)}
end

(["  "] + (1..199).map{|n|"%2s" % M(n)}).each_slice(20){|line| puts line.join(" ") }

ar = (1..1000).map{|n| M(n)}
puts "\nThe Mertens function is zero #{ar.count(0)} times in the range (1..1000);"
puts "it crosses zero #{ar.each_cons(2).count{|m1, m2| m1 != 0 && m2 == 0}} times."
