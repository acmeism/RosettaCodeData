n = 2200
l_add, l = {}, {}
1.step(n) do |x|
  x2 = x*x
  x.step(n) {|y| l_add[x2 + y*y] = true}
end

s = 3
1.step(n) do |x|
  s1 = s
  s += 2
  s2 = s
  (x+1).step(n) do |y|
    l[y] = true if l_add[s1]
    s1 += s2
    s2 += 2
  end
end

puts (1..n).reject{|x| l[x]}.join(" ")
