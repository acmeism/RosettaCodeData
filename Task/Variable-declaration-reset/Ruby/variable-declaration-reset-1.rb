s = [1, 2, 2, 3, 4, 4, 5]

for i in 0..6
  curr = s[i]
  prev = prev
  if i>0 and curr==prev then
    puts i
  end
  prev = curr
end
