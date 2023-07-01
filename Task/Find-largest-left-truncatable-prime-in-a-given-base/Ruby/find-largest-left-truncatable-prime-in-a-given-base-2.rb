# Compute the largest left truncatable prime
#
#  Nigel_Galloway
#  September 15th., 2012.
#
require 'prime'
require 'java'
BASE = 10
MAX = 500
stems = Prime.each(BASE-1).to_a
(1..MAX-1).each {|i|
  print "#{stems.length} "
  t = []
  b = BASE ** i
  stems.each {|z|
    (1..BASE-1).each {|n|
      c = n*b+z
      t.push(c) if java.math.BigInteger.new(c.to_s).isProbablePrime(100)
  }}
  break if t.empty?
  stems = t
}
puts "\nThe largest left truncatable prime #{"less than #{BASE ** MAX} " if MAX < 500}in base #{BASE} is #{stems.max}"
