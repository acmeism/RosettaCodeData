USING: circular formatting io kernel math qw sequences
sequences.repeating ;
IN: rosetta-code.zodiac

<PRIVATE

! Offset start index by -4 because first cycle started on 4 CE.
: circularize ( seq -- obj )
    [ -4 ] dip <circular> [ change-circular-start ] keep ;

: animals ( -- obj )
    qw{
        Rat Ox Tiger Rabbit Dragon Snake Horse Goat Monkey
        Rooster Dog Pig
    } circularize ;

: elements ( -- obj )
    qw{ Wood Fire Earth Metal Water } 2 <repeats> circularize ;

PRIVATE>

: zodiac ( n -- str )
    dup [ elements nth ] [ animals nth ]
    [ even? "yang" "yin" ? ] tri
    "%d is the year of the %s %s (%s)." sprintf ;

: zodiac-demo ( -- )
    { 1935 1938 1968 1972 1976 1984 1985 2017 }
    [ zodiac print ] each ;

MAIN: zodiac-demo
