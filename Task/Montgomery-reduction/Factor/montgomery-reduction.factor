USING: io kernel locals math math.bitwise math.functions
prettyprint ;

: montgomery-reduce ( m a -- n )
    over bit-length [ dup odd? [ over + ] when 2/ ] times
    swap mod ;

CONSTANT: m 750791094644726559640638407699
CONSTANT: t1 323165824550862327179367294465482435542970161392400401329100

CONSTANT: r1 440160025148131680164261562101
CONSTANT: r2 435362628198191204145287283255

CONSTANT: x1 540019781128412936473322405310
CONSTANT: x2 515692107665463680305819378593

"Original x1:       " write x1 .
"Recovered from r1: " write m r1 montgomery-reduce .
"Original x2:       " write x2 .
"Recovered from r2: " write m r2 montgomery-reduce .

nl "Montgomery computation of x1^x2 mod m:    " write

[let
    m t1 x1 / montgomery-reduce :> prod!
    m t1 montgomery-reduce :> base!
    x2 :> exponent!

    [ exponent zero? ] [
        exponent odd?
        [ m prod base * montgomery-reduce prod! ] when
        m base sq montgomery-reduce base! exponent 2/ exponent!
    ] until

    m prod montgomery-reduce .
    "Library-based computation of x1^x2 mod m: " write
    x1 x2 m ^mod .
]
