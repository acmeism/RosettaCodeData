! rosettacode/ternary/ternary.factor
! http://rosettacode.org/wiki/Ternary_logic
USING: combinators kernel ;
IN: rosettacode.ternary

SINGLETON: m
UNION: trit t m POSTPONE: f ;

GENERIC: >trit ( object -- trit )
M: trit >trit ;

: tnot ( trit1 -- trit )
    >trit { { t [ f ] } { m [ m ] } { f [ t ] } } case ;

: tand ( trit1 trit2 -- trit )
    >trit {
        { t [ >trit ] }
        { m [ >trit { { t [ m ] } { m [ m ] } { f [ f ] } } case ] }
        { f [ >trit drop f ] }
    } case ;

: tor ( trit1 trit2 -- trit )
    >trit {
        { t [ >trit drop t ] }
        { m [ >trit { { t [ t ] } { m [ m ] } { f [ m ] } } case ] }
        { f [ >trit ] }
    } case ;

: txor ( trit1 trit2 -- trit )
    >trit {
        { t [ tnot ] }
        { m [ >trit drop m ] }
        { f [ >trit ] }
    } case ;

: t= ( trit1 trit2 -- trit )
    {
        { t [ >trit ] }
        { m [ >trit drop m ] }
        { f [ tnot ] }
    } case ;
