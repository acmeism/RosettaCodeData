USING: formatting kernel math ranges sequences ;
IN: rosetta-code.needs-a..f?

: quads ( n -- seq )
    [ dup 0 > ] [ 16 /mod ] produce nip ;

: needs-a..f? ( n -- ? )
    quads [ 9 > ] any? ;

500 [1..b] [ needs-a..f? ] filter [ "%d " printf ] each
