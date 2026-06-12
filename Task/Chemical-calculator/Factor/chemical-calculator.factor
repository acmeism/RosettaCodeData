USING: assocs compiler.units definitions grouping infix.parser
infix.private kernel math.functions math.parser multiline
peg.ebnf qw sequences splitting strings words words.constant ;
IN: rosetta-code.chemical-calculator

<<     ! Do the stuff inside << ... >> at parse time.

HEREDOC: END
H  1.008         He 4.002602      Li 6.94
Be 9.0121831     B  10.81         C  12.011
N  14.007        O  15.999        F  18.998403163
Ne 20.1797       Na 22.98976928   Mg 24.305
Al 26.9815385    Si 28.085        P  30.973761998
S  32.06         Cl 35.45         Ar 39.948
K  39.0983       Ca 40.078        Sc 44.955908
Ti 47.867        V  50.9415       Cr 51.9961
Mn 54.938044     Fe 55.845        Co 58.933194
Ni 58.6934       Cu 63.546        Zn 65.38
Ga 69.723        Ge 72.630        As 74.921595
Se 78.971        Br 79.904        Kr 83.798
Rb 85.4678       Sr 87.62         Y  88.90584
Zr 91.224        Nb 92.90637      Mo 95.95
Ru 101.07        Rh 102.90550     Pd 106.42
Ag 107.8682      Cd 112.414       In 114.818
Sn 118.710       Sb 121.760       Te 127.60
I  126.90447     Xe 131.293       Cs 132.90545196
Ba 137.327       La 138.90547     Ce 140.116
Pr 140.90766     Nd 144.242       Pm 145
Sm 150.36        Eu 151.964       Gd 157.25
Tb 158.92535     Dy 162.500       Ho 164.93033
Er 167.259       Tm 168.93422     Yb 173.054
Lu 174.9668      Hf 178.49        Ta 180.94788
W  183.84        Re 186.207       Os 190.23
Ir 192.217       Pt 195.084       Au 196.966569
Hg 200.592       Tl 204.38        Pb 207.2
Bi 208.98040     Po 209           At 210
Rn 222           Fr 223           Ra 226
Ac 227           Th 232.0377      Pa 231.03588
U  238.02891     Np 237           Pu 244
Am 243           Cm 247           Bk 247
Cf 251           Es 252           Fm 257
END

! Make constants from the pairs in the above string.
" \n" split harvest 2 <groups> [
    first2 [
        [ "rosetta-code.chemical-calculator" create-word ] dip
        string>number define-constant
    ] 2curry with-compilation-unit
] each

>>

! Evaluate a string like "+C+O+O+H+(+C+(+C+H*3)*2)*3+C+H*3"
! Note that the infix vocabulary can work with the constants
! defined above.
: eval-infix ( seq -- n )
    build-infix-ast infix-codegen prepare-operand call( -- x ) ;

! A grammar to put a + before every element/left paren and a *
! before every number and then evaluate the expression.
EBNF: molar-mass [=[
  number = [0-9]+ => [[ "" like "*" prepend ]]
  elt = [A-Z] [a-z]? [a-z]? => [[ sift "" like "+" prepend ]]
  lparen = "(" => [[ "" like "+" prepend ]]
  any = . => [[ 1string ]]
  mass = (elt|number|lparen|any)+ => [[ concat eval-infix ]]
]=]

! assert= doesn't work due to floating point weirdness.
ERROR: failed-assertion expected +/- got ;
: approx-assert= ( x y epsilon -- )
    3dup ~ [ 3drop ] [ swap failed-assertion ] if ;

: chemical-calculator-demo ( -- )
    {
        { 1.008 "H" }
        { 2.016 "H2" }
        { 18.015 "H2O" }
        { 142.03553856 "Na2SO4" }
        { 84.16200000000001 "C6H12" }
        { 186.295 "COOH(C(CH3)2)3CH3" }
    } [ molar-mass 1e-5 approx-assert= ] assoc-each ;

MAIN: chemical-calculator-demo
