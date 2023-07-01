USING: formatting fry io kernel locals math math.ranges
sequences ;
IN: rosetta-code.euler-method

:: euler ( quot y! a b h -- )
    a b h <range> [
        :> t
        t y "%7.3f %7.3f\n" printf
        t y quot call h * y + y!
    ] each ; inline

: cooling ( t y -- x ) nip 20 - -0.07 * ;

: euler-method-demo ( -- )
   2 5 10 [ '[ [ cooling ] 100 0 100 _ euler ] call nl ] tri@ ;

MAIN: euler-method-demo
