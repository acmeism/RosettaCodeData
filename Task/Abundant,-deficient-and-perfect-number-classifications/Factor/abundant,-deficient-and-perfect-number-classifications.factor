USING: fry math.primes.factors math.ranges ;
: psum     ( n -- m )   divisors but-last sum ;
: pcompare ( n -- <=> ) dup psum swap <=> ;
: classify ( -- seq )   20,000 [1,b] [ pcompare ] map ;
: pcount   ( <=> -- n ) '[ _ = ] count ;
classify [ +lt+ pcount "Deficient: " write . ]
         [ +eq+ pcount "Perfect: "   write . ]
         [ +gt+ pcount "Abundant: "  write . ] tri
