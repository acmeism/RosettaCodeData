@memo = [0,1]
def happy(n)
  sum = n.to_s.chars.map{|c| c.to_i**2}.inject(:+)
  return @memo[sum] if @memo[sum]==0 or @memo[sum]==1
  @memo[sum] = 0                        # for the cycle check
  @memo[sum] = happy(sum)               # return 1:Happy number, 0:other
end

i = count = 0
while count < 8
  i += 1
  puts i or count+=1 if happy(i)==1
end

puts
for i in 99999999999900..99999999999999
  puts i if happy(i)==1
end
