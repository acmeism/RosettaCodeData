# brute force approach
i = Math.isqrt(269_696)
i -= 1 unless i.even?
while i*i % 1_000_000 != 269_696
  i += 2
end
p i
