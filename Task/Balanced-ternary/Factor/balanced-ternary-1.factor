USING: kernel combinators locals formatting lint literals
       sequences assocs strings arrays
       math math.functions math.order ;
IN: rosetta-code.bt
CONSTANT: addlookup {
  { 0 CHAR: 0 }
  { 1 CHAR: + }
  { -1 CHAR: - }
}

<PRIVATE

: bt-add-digits ( a b c -- d e )
  + + 3 +
  { { 0 -1 } { 1 -1 } { -1 0 } { 0 0 } { 1 0 } { -1 1 } { 0 1 } }
  nth first2
;

PRIVATE>

! Conversion
: bt>integer ( seq -- x ) 0 [ swap 3 * + ] reduce ;
: integer>bt ( x -- x ) [ dup zero? not ] [
    dup 3 rem {
      { 0 [ 3 / 0 ] }
      { 1 [ 3 / round 1 ] }
      { 2 [ 1 + 3 / round -1 ] }
    } case
  ] produce nip reverse
;
: bt>string ( seq -- str ) [ addlookup at ] map >string ;
: string>bt ( str -- seq ) [ addlookup value-at ] { } map-as ;

! Arithmetic
: bt-neg ( a -- -a ) [ neg ] map ;
:: bt-add ( u v -- w )
  u v max-length :> maxl
  u v [ maxl 0 pad-head reverse ] bi@ :> ( u v )
  0 :> carry!
  u v { } [ carry bt-add-digits carry! prefix ] 2reduce
  carry prefix [ zero? ] trim-head
;
: bt-sub ( u v -- w ) bt-neg bt-add ;
:: bt-mul ( u v -- w ) u { } [
    {
      { -1 [ v bt-neg ] }
      { 0  [ { } ] }
      { 1  [ v ] }
    } case bt-add 0 suffix
  ] reduce
  1 head*
;

[let
  "+-0++0+" string>bt :> a
  -436 integer>bt     :> b
  "+-++-" string>bt   :> c
  b c bt-sub a bt-mul :> d
  "a" a bt>integer a bt>string "%s: %d, %s\n" printf
  "b" b bt>integer b bt>string "%s: %d, %s\n" printf
  "c" c bt>integer c bt>string "%s: %d, %s\n" printf
  "a*(b-c)" d bt>integer d bt>string "%s: %d, %s\n" printf
]
