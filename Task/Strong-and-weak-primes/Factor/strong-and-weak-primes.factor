USING: formatting grouping kernel math math.primes sequences
tools.memory.private ;
IN: rosetta-code.strong-primes

: fn ( p-1 p p+1 -- p sum ) rot + 2 / ;
: strong? ( p-1 p p+1 -- ? ) fn > ;
: weak? ( p-1 p p+1 -- ? ) fn < ;

: swprimes ( seq quot -- seq )
    [ 3 <clumps> ] dip [ first3 ] prepose filter [ second ] map
    ; inline

: stats ( seq n -- firstn count1 count2 )
    [ head ] [ drop [ 1e6 < ] filter length ] [ drop length ]
    2tri [ commas ] bi@ ;

10,000,019 primes-upto [ strong? ] over [ weak? ]
[ swprimes ] 2bi@ [ 36 ] [ 37 ] bi* [ stats ] 2bi@

"First 36 strong primes:\n%[%d, %]
%s strong primes below 1,000,000
%s strong primes below 10,000,000\n
First 37 weak primes:\n%[%d, %]
%s weak primes below 1,000,000
%s weak primes below 10,000,000\n" printf
