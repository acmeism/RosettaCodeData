def vdc(n, base=2)
  str = n.to_s(base).reverse
  str.to_i(base).quo(base ** str.length)
end

(2..5).each do |base|
  puts "Base #{base}: " + Array.new(10){|i| vdc(i,base)}.join(", ")
end
