# Compute the largest left truncatable prime
#
#  Nigel_Galloway
#  September 15th., 2012.
#
require 'prime'
BASE = 3
MAX = 500
stems = Prime.each(BASE-1).to_a
(1..MAX-1).each {|i|
  print "#{stems.length} "
  t = []
  b = BASE ** i
  stems.each {|z|
    (1..BASE-1).each {|n|
      c = n*b+z
      t.push(c) if c.prime?
  }}
  break if t.empty?
  stems = t
}
puts "The largest left truncatable prime #{"less than #{BASE ** MAX} " if MAX < 500}in base #{BASE} is #{stems.max}"
