def eratosthenes(n)
  nums = [nil, nil, *2..n]
  (2..Math.sqrt(n)).each do |i|
    (i**2..n).step(i){|m| nums[m] = nil}  if nums[i]
  end
  nums.compact
end

p eratosthenes(100)
