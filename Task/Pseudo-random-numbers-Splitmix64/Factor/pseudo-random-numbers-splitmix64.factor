USING: io kernel math math.bitwise math.functions
math.statistics namespaces prettyprint sequences ;

SYMBOL: state

: seed ( n -- ) 64 bits state set ;

: next-int ( -- n )
    0x9e3779b97f4a7c15 state [ + 64 bits ] change
    state get -30 0xbf58476d1ce4e5b9 -27 0x94d049bb133111eb -31 1
    [ [ dupd shift bitxor ] dip * 64 bits ] 2tri@ ;

: next-float ( -- x ) next-int 64 2^ /f ;

! Test next-int
"Seed: 1234567; first five integer values" print
1234567 seed 5 [ next-int . ] times nl

! Test next-float
"Seed: 987654321; first 100,000 float values histogram" print
987654321 seed 100,000 [ next-float 5 * >integer ] replicate
histogram .
