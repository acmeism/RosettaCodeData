def vdc (n, base=2)
  str = n.to_s(base).reverse
  str.to_i(base) / (base ** str.size)
end

(2..5).each do |base|
  puts "Base #{base}: " + Array.new(10){|i| vdc(i,base)}.join(", ")
end
