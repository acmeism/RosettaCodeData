USING: formatting kernel lists lists.lazy math math.parser qw
sequences ;
IN: rosetta-code.cf-arithmetic

: r2cf ( x -- lazy )
    [ >fraction [ /mod ] keep swap [ ] [ / ] if-zero nip ]
    lfrom-by [ integer? ] luntil [ >fraction /i ] lmap-lazy ;

: main ( -- )
    qw{
        1/2
        3
        23/8
        13/11
        22/7
        -151/77
        14142/10000
        141421/100000
        1414214/1000000
        14142136/10000000
        31/10
        314/100
        3142/1000
        31428/10000
        314285/100000
        3142857/1000000
        31428571/10000000
        314285714/100000000
    }
    [ dup string>number r2cf list>array "%19s -> %u\n" printf ]
    each ;

MAIN: main
