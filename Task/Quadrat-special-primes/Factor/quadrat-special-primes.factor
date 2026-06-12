USING: fry io kernel lists lists.lazy math math.primes prettyprint ;

2 [ 1 lfrom swap '[ sq _ + ] lmap-lazy [ prime? ] lfilter car ]
lfrom-by [ 16000 < ] lwhile [ pprint bl ] leach nl
