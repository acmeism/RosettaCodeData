res =(1..1000).select do |n|
  digits = n.digits
  next if digits.include? 0
  digits.uniq.all?{|d| n%d == 0} &! (n % digits.inject(:*) == 0)
end

p res
