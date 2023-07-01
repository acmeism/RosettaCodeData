DIGITS = "1023456789abcdefghijklmnopqrstuvwxyz"

2.upto(16) do |n|
  start = Integer.sqrt( DIGITS[0,n].to_i(n) )
  res = start.step.detect{|i| (i*i).digits(n).uniq.size == n }
  puts "Base %2d:%10s² = %-14s" % [n, res.to_s(n), (res*res).to_s(n)]
end
