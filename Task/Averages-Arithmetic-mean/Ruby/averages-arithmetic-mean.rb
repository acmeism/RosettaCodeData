def mean(nums)
  nums.inject(0.0, :+) / nums.size
end

nums = [3, 1, 4, 1, 5, 9]
nums.size.downto(0) do |i|
  ary = nums[0,i]
  puts "array size #{ary.size} : #{mean(ary)}"
end
