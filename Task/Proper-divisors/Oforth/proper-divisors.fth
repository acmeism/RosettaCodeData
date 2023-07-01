Integer method: properDivs  self 2 / seq filter(#[ self swap mod 0 == ]) }

10 seq apply(#[ dup print " : " print properDivs println ])
20000 seq map(#[ dup properDivs size Pair new ]) reduce(#maxKey) println
