Prelude Main> qSeqTest 1000 100000    -- reversals in 100,000
([1,1,2,3,3,4,5,5,6,6],502,49798)
(0.09 secs, 18879708 bytes)

Prelude Main> qSeqTest 1000000 100000   -- 1,000,000-th item
([1,1,2,3,3,4,5,5,6,6],512066,49798)
(2.80 secs, 87559640 bytes)
