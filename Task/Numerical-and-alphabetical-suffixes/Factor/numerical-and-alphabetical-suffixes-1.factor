USING: combinators combinators.short-circuit formatting fry
grouping grouping.extras kernel literals math math.functions
math.parser math.ranges qw regexp sequences sequences.deep
sequences.extras sets splitting unicode ;
IN: rosetta-code.numerical-suffixes

CONSTANT: test-cases {
    qw{ 2greatGRo 24Gros 288Doz 1,728pairs 172.8SCOre }
    qw{ 1,567 +1.567k 0.1567e-2m }
    qw{ 25.123kK 25.123m 2.5123e-00002G }
    qw{ 25.123kiKI 25.123Mi 2.5123e-00002Gi +.25123E-7Ei }
    qw{ -.25123e-34Vikki 2e-77gooGols }
    qw{
        9! 9!! 9!!! 9!!!! 9!!!!! 9!!!!!! 9!!!!!!! 9!!!!!!!!
        9!!!!!!!!!
    }
}

CONSTANT: alpha {
    { "PAIRs" 2 } { "DOZens" 12 } { "SCOres" 20 }
    { "GRoss" 144 } { "GREATGRoss" 1,728 }
    ${ "GOOGOLs" 10 100 ^ }
}

CONSTANT: metric qw{ K M G T P E Z Y X W V U }

! Multifactorial
: m! ( n degree -- m ) neg 1 swap <range> product ;

! Separate a number from its suffix(es).
! e.g. "+1.567k" -> 1.567 "k"
: num/suffix ( str -- n suffix(es) )
    dup <head-clumps> <reversed> { } like "" map-like
    [ string>number ] map [ ] find [ tail* ] dip swap ;

! Checks whether str1 is an abbreviation of str2.
! e.g. "greatGRo" "GREATGRoss" -> t
: abbrev? ( str1 str2 -- ? )
    {
        [ [ >upper ] [ [ LETTER? ] take-while head? ] bi* ]
        [ [ length ] bi@ <= ]
    } 2&& ;

! Convert an alpha suffix to its multiplication function.
! e.g. "Doz" -> [ 12 * ]
: alpha>quot ( str -- quot )
    [ alpha ] dip '[ first _ swap abbrev? ] find nip second
    [ * ] curry ;

! Split a suffix composed of metric and binary suffixes into its
! constituent parts. e.g. "Vikki" -> { "Vi" "k" "ki" }
: split-compound ( str -- seq )
    R/ (.i|.)/i all-matching-subseqs ;

! Convert a metric or binary suffix to its multiplication
! function. e.g. "k" -> [ 10 3 ^ * ]
: suffix>quot ( str -- quot )
    dup [ [ 0 1 ] dip subseq >upper metric index 1 + ] dip
    length 1 = [ 3 * '[ 10 _ ^ * ] ] [ 10 * '[ 2 _ ^ * ] ] if ;

! Apply suffix>quot to each member of a sequence.
! e.g. { "Vi" "k" "ki" } ->
! [ [ 2 110 ^ * ] [ 10 3 ^ * ] [ 2 10 ^ * ] ]
: map-suffix ( seq -- seq' ) [ suffix>quot ] [ ] map-as ;

! Tests whether a string is composed of metric and/or binary
! suffixes. e.g. "Vikki" -> t
: compound? ( str -- ? )
    >upper metric concat "I" append without empty? ;

! Convert a float to an integer if it is numerically equivalent
! to an integer. e.g. 1.0 -> 1, 1.23 -> 1.23
: ?f>i ( x -- y/n )
    dup >integer 2dup [ number= ] 2dip swap ? ;

! Convert a suffix string to a function that performs the
! calculations required by the suffix.
! e.g. "!!!" -> [ 3 m! ], "kiKI" -> [ 2 10 ^ * 2 10 ^ * ]
: parse-suffix ( str -- quot )
    {
        { [ dup empty? ] [ drop [ ] ] }
        { [ dup first CHAR: ! = ] [ length [ m! ] curry ] }
        { [ dup compound? ] [ split-compound map-suffix ] }
        [ alpha>quot ]
    } cond flatten ;

GENERIC: commas ( n -- str )

! Add commas to an integer in triplets.
! e.g. 1567 -> "1,567"
M: integer commas number>string <reversed> 3 group
    [ "," append ] map concat reverse rest ;

! Add commas to a float in triplets.
! e.g. 1567.12345 -> "1,567.12345"
M: float commas number>string "." split first2
    [ string>number commas ] dip "." glue ;

! Parse any number with any numerical or alphabetical suffix.
! e.g. "288Doz" -> "3,456", "9!!" -> "945"
: parse-alpha ( str -- str' )
    num/suffix parse-suffix curry call( -- x ) ?f>i commas ;

: main ( -- )
    test-cases [
        dup [ parse-alpha ] map
        "Numbers: %[%s, %]\n Result: %[%s, %]\n\n" printf
    ] each ;

MAIN: main
