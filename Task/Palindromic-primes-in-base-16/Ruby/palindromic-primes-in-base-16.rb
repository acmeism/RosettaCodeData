require 'prime'
res = Prime.each(500).filter_map do |pr|
  str = pr.to_s(16)
  str if str == str.reverse
end
puts res.join(", ")
