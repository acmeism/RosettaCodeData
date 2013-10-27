(5..8).each do |digit|
  n2 = 10 ** (digit-1)
  n1 = (Math.sqrt(2) * n2).round
  print "%-8s / %-8s : " % [n1, n2]
  r2cf(n1,n2) {|n| print "#{n} "}
  puts
end
