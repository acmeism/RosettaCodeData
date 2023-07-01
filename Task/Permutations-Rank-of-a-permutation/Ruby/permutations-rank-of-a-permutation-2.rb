puts "All permutations of 3 items from and back to rank."
perm = Permutation.new(3)
(0...perm.size).each{|num| puts "#{num} --> #{prm=perm.unrank(num)} --> #{perm.rank(prm)}"}

puts "\n4 random samples of 12 items from and back to rank."
perm = Permutation.new(12)
4.times{ puts "%9d --> %s --> %9d" % [r=rand(perm.size), prm=perm.unrank(r), perm.rank(prm)]}

puts "\n4 random uniq samples of 144 items:"
perm, rands = Permutation.new(144), {}
# generate 1_000_000 unique random numbers in the range (0...144!) (takes about 2.5 seconds)
rands[rand(perm.size)] = true until rands.size == 1_000_000

random_perms = rands.each_key.lazy{|k| perm.unrank(k)}
# random_perms is lazy. Generate permutations one by one:
4.times do
  p r = random_perms.next
  p prm = perm.unrank(r)
  p perm.rank(prm) == r
end
