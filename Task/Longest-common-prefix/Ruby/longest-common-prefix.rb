def lcp(*strs)
  return "" if strs.empty?
  min, max = strs.minmax
  idx = min.size.times{|i| break i if min[i] != max[i]}
  min[0...idx]
end

data = [
  ["interspecies","interstellar","interstate"],
  ["throne","throne"],
  ["throne","dungeon"],
  ["throne","","throne"],
  ["cheese"],
  [""],
  [],
  ["prefix","suffix"],
  ["foo","foobar"]
]

data.each do |set|
  puts "lcp(#{set.inspect[1..-2]}) = #{lcp(*set).inspect}"
end
