USING: io kernel sequences.interleaved sets sorting ;

{ "1a3c52debeffd" "2b6178c97a938sf" "3ycxdb1fgxa2yz" }
[ intersect-all ] [ [ duplicates ] gather without ] bi
natural-sort CHAR: space <interleaved> print

! How it works:
! intersect-all           obtain elements present in every string                        ->  "1a3c2bf"
! [ duplicates ] gather   obtain elements that repeat within a single string             ->  "efd798xy"
! without                 from the first string, remove elements that are in the second  ->  "1a3c2b"
