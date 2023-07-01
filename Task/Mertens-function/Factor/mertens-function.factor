USING: formatting grouping io kernel math math.extras
math.ranges math.statistics prettyprint sequences ;

! Take the cumulative sum of the mobius sequence to avoid
! summing lower terms over and over.
: mertens-upto ( n -- seq ) [1,b] [ mobius ] map cum-sum ;

"The first 199 terms of the Mertens sequence:" print
199 mertens-upto " " prefix 20 group
[ [ "%3s" printf ] each nl ] each nl

"In the first 1,000 terms of the Mertens sequence there are:"
print 1000 mertens-upto
[ [ zero? ] count bl pprint bl "zeros." print ]
[
    2 <clumps> [ first2 [ 0 = not ] [ zero? ] bi* and ] count bl
    pprint bl "zero crossings." print
] bi
