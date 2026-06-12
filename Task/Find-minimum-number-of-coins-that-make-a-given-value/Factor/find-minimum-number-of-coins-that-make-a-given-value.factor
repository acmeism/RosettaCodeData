USING: assocs kernel math math.order prettyprint sorting ;

: make-change ( value coins -- assoc )
    [ >=< ] sort [ /mod swap ] zip-with nip ;

988 { 1 2 5 10 20 50 100 200 } make-change .
