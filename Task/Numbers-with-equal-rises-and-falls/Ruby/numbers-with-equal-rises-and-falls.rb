class Integer
  def eq_rise_fall? = digits.each_cons(2).sum{|a,b| a <=> b} == 0
end

puts (1..).lazy.select(&:eq_rise_fall?).take(200).force.join(" ")

n = 10_000_000
res = (1..).lazy.select(&:eq_rise_fall?).take(n).drop(n-1).first
puts "The #{n}th number in the sequence is #{res}."
