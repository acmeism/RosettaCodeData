def sb
  return enum_for :sb unless block_given?
  a=[1,1]
  0.step do |i|
    yield a[i]
    a << a[i]+a[i+1] << a[i+1]
  end
end

puts "First 15: #{sb.first(15)}"

[*1..10,100].each do |n|
  puts "#{n} first appears at #{sb.find_index(n)+1}."
end

if sb.take(1000).each_cons(2).all? { |a,b| a.gcd(b) == 1 }
  puts "All GCD's are 1"
else
  puts "Whoops, not all GCD's are 1!"
end
