def unrank(n)
  return [0] if n==1
  n.to_s(2)[1..-1].split('0',-1).map(&:size)
end

def rank(x)
  return 0 if x.empty?
  ('1' + x.map{ |a| '1'*a }.join('0')).to_i(2)
end

for x in 0..10
  puts "%3d : %-18s: %d" % [x, a=unrank(x), rank(a)]
end

puts
x = [1, 2, 3, 5, 8]
puts "#{x} => #{rank(x)} => #{unrank(rank(x))}"
