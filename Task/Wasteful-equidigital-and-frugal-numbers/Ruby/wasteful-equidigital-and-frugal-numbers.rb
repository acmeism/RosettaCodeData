require 'prime'

[10,11].each do |base|
  res = Hash.new{|h, k| h[k] = [] }
  puts "\nBase: #{base}"

  (1..).each do |n|
    pd = n.prime_division
    pd = pd.map{|pr| pr.pop if pr.last == 1; pr}
    pd = [1] if n == 1
    selector = n.digits(base).size <=> pd.flatten.sum{|m| m.digits(base).size} # -1,0,1
    res[[:Equidigital, :Frugal, :Wasteful][selector]] << n
    break if res.values.all?{|v| v.size >= 10000}
  end

  res.each do |k, v|
    puts "#{k}:"
    puts "10000th: #{v[9999]}; count: #{v.count{|n| n < 1_000_000}}"
    p v.first(50)
  end
end
