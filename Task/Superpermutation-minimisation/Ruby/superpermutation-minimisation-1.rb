#A straight forward implementation of N. Johnston's algorithm. I prefer to look at this as 2n+1 where
#the second n is first n reversed, and the 1 is always the second symbol. This algorithm will generate
#just the left half of the result by setting l to [1,2] and looping from 3 to 6. For the purpose of
#this task I am going to start from an empty array and generate the whole strings using just the
#rules.
#
#Nigel Galloway: December 16th., 2014
#
l = []
(1..6).each{|e|
  a, i = [], e-2
  (0..l.length-e+1).each{|g|
     if not (n = l[g..g+e-2]).uniq!
       a.concat(n[(a[0]? i : 0)..-1]).push(e).concat(n)
       i = e-2
     else
       i -= 1
     end
   }
   a.each{|n| print n}; puts "\n\n"
   l = a
}
