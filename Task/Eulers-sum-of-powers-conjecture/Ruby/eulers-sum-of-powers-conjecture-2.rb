p5, sum2, max = {}, {}, 250
(1..max).each do |i|
  p5[i**5] = i
  (i..max).each{|j| sum2[i**5 + j**5] = [i,j]}
end

result = {}
sk = sum2.keys.sort
p5.keys.sort.each do |p|
  sk.each do |s|
    break if p <= s
    result[(sum2[s] + sum2[p-s]).sort] = p5[p]  if sum2[p - s]
  end
end
result.each{|k,v| puts k.map{|i| "#{i}**5"}.join(' + ') + " = #{v}**5"}
