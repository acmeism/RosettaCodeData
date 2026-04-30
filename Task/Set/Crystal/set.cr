# Several ways to create a set:
s1 = [1, 2, 3, 4].to_set
s2 = Set{3, 4, 5, 6}
s3 = Set.new [1, 2, 3, 4]

# To create an empty set, the type of its elements needs to be specified:
s4 = Set(Int32).new

p! s1, s2, s3

puts "\nTest inclusion:"
p! 2.in?(s1),
   s1.includes?(5)

puts "\nUnion:"
p! s1 + s2

puts "\nIntersection:"
p! s1 & s2

puts "\nDifference (symmetric):"
p! s1 - s2, s1 ^ s2

puts "\nSubset (proper):"
p! s1.subset_of?(s3),
   s1.proper_subset_of?(s3)

puts "\nEquality:"
p! s1 == s2, s1 == s3

puts "\nAdd element:"
p! s1, s1.add(5), s1
