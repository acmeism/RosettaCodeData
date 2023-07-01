require "prime"
limit = 1_000_000

puts "First found longest run of ascending prime gaps up to #{limit}:"
p  Prime.each(limit).each_cons(2).chunk_while{|(i1,i2), (j1,j2)| j1-i1 < j2-i2 }.max_by(&:size).flatten.uniq
puts  "\nFirst found longest run of descending prime gaps up to #{limit}:"
p  Prime.each(limit).each_cons(2).chunk_while{|(i1,i2), (j1,j2)| j1-i1 > j2-i2 }.max_by(&:size).flatten.uniq
