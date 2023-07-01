USING: formatting inverse io kernel math prettyprint quotations
sequences units.imperial units.si vocabs ;
IN: rosetta-code.units.russian

: arshin  ( n -- d ) 2+1/3 * feet ;
: tochka  ( n -- d ) 1/2800 * arshin ;
: liniya  ( n -- d ) 1/280 * arshin ;
: dyuim   ( n -- d ) 1/28 * arshin ;
: vershok ( n -- d ) 1/16 * arshin ;
: ladon   ( n -- d ) 7+1/2 * cm ;
: piad    ( n -- d ) 1/4 * arshin ;
: fut     ( n -- d ) 3/7 * arshin ;
: lokot   ( n -- d ) 45 * cm ;
: shag    ( n -- d ) 71 * cm ;
: sazhen  ( n -- d ) 3 * arshin ;
: versta  ( n -- d ) 1,500 * arshin ;
: milya   ( n -- d ) 10,500 * arshin ;

<PRIVATE

: convert ( quot -- )
    [ unparse rest rest but-last write "to:" print ] [ call ] bi
    "rosetta-code.units.russian" vocab-words { cm m km } append
    [ dup "%8u : " printf 1quotation [undo] call( x -- x ) . ]
    with each nl ; inline

: main ( -- )
    [ 6 m ] [ 1+7/8 milya ] [ 2 furlongs ] [ convert ] tri@ ;

PRIVATE>

MAIN: main
