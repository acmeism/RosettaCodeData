USING: accessors formatting grouping io kernel math
math.functions.integer-logs math.parser random regexp sequences ;

: new-dna ( n -- str ) [ "ACGT" random ] "" replicate-as ;

: pad ( n d -- str ) [ number>string ] dip 32 pad-head ;

:: .dna ( seq n -- )
    seq length integer-log10 1 + :> d seq n group
    [ n * d pad write ": " write write nl ] each-index ;

: .match ( slice -- ) [ from>> ] [ to>> ] bi "%d..%d\n" printf ;

: .matches ( slices -- )
    "Matches found at the following indices:" print
    [ .match ] each ;

: .locate ( slices -- )
    [ "No matches found." print ] [ .matches ] if-empty ;

: .biosub ( dna-size row-size -- )
    [ new-dna dup ] [ .dna nl ] bi*
    4 new-dna dup "Subsequence to locate: %s\n" printf
    <regexp> all-matching-slices .locate ;

80 10 .biosub nl
600 39 .biosub nl
