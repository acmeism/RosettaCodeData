USING: formatting fry http.client io kernel lcs literals math
math.ranges namespaces prettyprint.config sequences splitting ;

CONSTANT: words $[
    "https://www.mit.edu/~ecprice/wordlist.10000" http-get nip
    "\n" split harvest
]
CONSTANT: word "complition"

: lev-dist-of ( str n -- n )
    [ words ] 2dip '[ _ levenshtein _ = ] filter ;

: similarity ( n -- x ) word length / 100 * 100 swap - ;

10000 margin set ! Prevent prettyprinter from wrapping sequences
4 [1,b] [
    dup [ similarity ] [ drop word ] [ word swap lev-dist-of ] tri
    "Words at Levenshtein distance of %d (%.1f%% similarity) from %u:\n%u\n\n" printf
] each
