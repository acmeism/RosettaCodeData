DICT=File.readlines("unixdict.txt").collect{|line| line.tr("\n", "")}
res=[]
i = 0
DICT.collect {|z| z.reverse}.sort.each {|z|
  i+=1 while z > DICT[i] and i < DICT.length-1
  res.push z if z.eql?(DICT[i]) and z < z.reverse
}
puts "There are #{res.length} semordnilaps, of which the following are 5:"
res.sample(5).each {|z| puts "#{z}   #{z.reverse}"}
