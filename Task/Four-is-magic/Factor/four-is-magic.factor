USING: ascii formatting io kernel make math.text.english regexp
sequences ;
IN: rosetta-code.four-is-magic

! Strip " and " and "," from the output of Factor's number>text
! word with a regular expression.
: number>english ( n -- str )
    number>text R/ and |,/ "" re-replace ;

! Return the length of the input integer's text form.
! e.g. 1 -> 3
: next-len ( n -- m ) number>english length ;

! Given a starting integer, return the sequence of lengths
! terminating with 4.
! e.g. 1 -> { 1 3 5 4 }
: len-chain ( n -- seq )
    [ [ dup 4 = ] [ dup , next-len ] until , ] { } make ;

! Convert a non-four number to its phrase form.
! e.g. 6 -> "six is three, "
: non-four ( n -- str )
    number>english dup length number>english
    "%s is %s, " sprintf ;

! Convert any number to its phrase form.
! e.g. 4 -> "four is magic."
: phrase ( n -- str )
    dup 4 = [ drop "four is magic." ] [ non-four ] if ;

: say-magic ( n -- )
    len-chain [ phrase ] map concat capitalize print ;

{ 1 4 -11 100 112719908181724 -612312 } [ say-magic ] each
