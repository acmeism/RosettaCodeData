dict = File.readlines("unixdict.txt").collect(&:strip)
i = 0
res = dict.collect(&:reverse).sort.select do |z|
  i += 1  while z > dict[i] and i < dict.length-1
  z == dict[i] and z < z.reverse
end
puts "There are #{res.length} semordnilaps, of which the following are 5:"
res.take(5).each {|z| puts "#{z}   #{z.reverse}"}
