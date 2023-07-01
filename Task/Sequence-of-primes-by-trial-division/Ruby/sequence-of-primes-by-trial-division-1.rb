require "prime"

pg = Prime::TrialDivisionGenerator.new
p pg.take(10) # => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
p pg.next # => 31
