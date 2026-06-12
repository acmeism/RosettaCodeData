list = [1, 2]
available = (1..50).to_a - list

loop do
  i = available.index{|a| list.last(2).all?{|b| a.gcd(b) == 1}}
  break if i.nil?
  list << available.delete_at(i)
end

puts list.join(" ")
