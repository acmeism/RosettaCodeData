def evolve(ary)
  new = Array.new(ary.length)
  new[0] = (ary[0] == 1 and ary[1] == 1) ? 1 : 0
  (1..new.length - 2).each {|i| new[i] = ary[i-1] + ary[i] + ary[i+1] == 2 ? 1 : 0}
  new[-1] = (ary[-2] == 1 and ary[-1] == 1) ? 1 : 0
  new
end

def printit(ary)
  s = ary.join("")
  s.gsub!(/1/,"#")
  s.gsub!(/0/,".")
  puts s
end

ary = [0,1,1,1,0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,0]
printit ary
while ary != new=evolve(ary)
  printit new
  ary = new
end
