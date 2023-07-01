require 'prime'
PRIMES = Prime.each(1_000_000).to_a
difs = [[2], [1], [2,2], [2,4], [4,2], [6,4,2]]

difs.each do |ar|
  res = PRIMES.each_cons(ar.size+1).select do |slice|
    slice.each_cons(2).zip(ar).all? {|(a,b), c| a+c == b}
  end
  puts "#{ar} has #{res.size} sets. #{res.first}...#{res.last}"
end
