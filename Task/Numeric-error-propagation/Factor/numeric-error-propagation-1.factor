USING: accessors arrays fry kernel locals math math.functions
multi-methods parser prettyprint prettyprint.custom sequences ;
RENAME: GENERIC: multi-methods => MM-GENERIC:
FROM: syntax => M: ;
IN: imprecise

TUPLE: imprecise
    { value float read-only }
    { sigma float read-only } ;

C: <imprecise> imprecise

: >imprecise< ( imprecise -- value sigma )
    [ value>> ] [ sigma>> ] bi ;

! Define a custom syntax for imprecise numbers.

<< SYNTAX: I{ \ } [ first2 <imprecise> ] parse-literal ; >>
M: imprecise pprint-delims drop \ I{ \ } ;
M: imprecise >pprint-sequence >imprecise< 2array ;
M: imprecise pprint* pprint-object ;

<PRIVATE

! Error functions

: f+-i ( float imprecise quot -- imprecise )
    [ >imprecise< ] dip dip <imprecise> ; inline

: i+-i ( imprecise1 imprecise2 quot -- imprecise )
    '[ [ value>> ] bi@ @ ]
    [ [ sigma>> sq ] bi@ + sqrt <imprecise> ] 2bi ; inline

: f*/i ( float imprecise quot -- imprecise )
    [ >imprecise< overd ] dip [ * abs ] 2bi* <imprecise> ;
    inline

:: i*/i ( a b quot -- imprecise )
    a b [ >imprecise< ] bi@ :> ( vala siga valb sigb )
    vala valb quot call :> val
    val sq siga sq * vala sq /f sigb sq + valb sq /f sqrt :> sig
    val sig <imprecise> ; inline

PRIVATE>

MM-GENERIC: ~+ ( obj1 obj2 -- imprecise ) foldable flushable
METHOD: ~+ { float imprecise } [ + ] f+-i ;
METHOD: ~+ { imprecise float } swap ~+ ;
METHOD: ~+ { imprecise imprecise } [ + ] i+-i ;

MM-GENERIC: ~- ( obj1 obj2 -- imprecise ) foldable flushable
METHOD: ~- { float imprecise } [ - ] f+-i ;
METHOD: ~- { imprecise float } swap [ swap - ] f+-i ;
METHOD: ~- { imprecise imprecise } [ - ] i+-i ;

MM-GENERIC: ~* ( obj1 obj2 -- imprecise ) foldable flushable
METHOD: ~* { float imprecise } [ * ] f*/i ;
METHOD: ~* { imprecise float } swap ~* ;
METHOD: ~* { imprecise imprecise } [ * ] i*/i ;

MM-GENERIC: ~/ ( obj1 obj2 -- imprecise ) foldable flushable
METHOD: ~/ { float imprecise } [ /f ] f*/i ;
METHOD: ~/ { imprecise float } swap [ swap /f ] f*/i ;
METHOD: ~/ { imprecise imprecise } [ /f ] i*/i ;

:: ~^ ( a x -- imprecise )
    a >imprecise< :> ( vala siga )
    vala x ^ >rect drop :> val
    val x * siga vala /f * abs :> sig
    val sig <imprecise> ; foldable flushable

<PRIVATE

: imprecise-demo ( -- )
    I{ 100 1.1 } I{ 200 2.2 } ~- 2. ~^
    I{ 50 1.2 } I{ 100 2.3 } ~- 2. ~^ ~+ 0.5 ~^ . ;

PRIVATE>

MAIN: imprecise-demo
