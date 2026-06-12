def common_sort (first, *rest)
  s = Set.new first
  rest.each do |a| s.concat(a) end
  s.to_a.sort!
end

p common_sort([5,1,3,8,9,4,8,7], [3,5,9,8,4], [1,3,7,9])
