USING: arrays kernel locals math math.functions math.vectors
prettyprint sequences sequences.extras ;
IN: uncertain

<PRIVATE

: ubi* ( x y p q -- u )
    [ [ first2 ] bi@ swapd ] 2dip 2bi* 2array ; inline

: err+ ( x y -- z ) [ sq ] bi@ + sqrt ;

:: (u*) ( u1 u2 quot -- u )
    u1 u2 [ first2 ] bi@ :> ( v1 s1 v2 s2 )
    v1 v2 quot call :> val
    s1 v1 /f sq s2 v2 /f sq + val sq * sqrt :> sig
    val sig 2array ; inline

PRIVATE>

: u+n ( u n -- u ) 0 2array v+ ;
: n+u ( n u -- u ) swap u+n ;
: u-n ( u n -- u ) 0 2array v- ;
: n-u ( n u -- u ) [ 0 2array ] dip v- ;
: u+  ( u u -- u ) [ + ] [ err+ ] ubi* ;
: u-  ( u u -- u ) [ - ] [ err+ ] ubi* ;
: u*n ( u n -- u ) dup 2array [ * ] [ * abs ] ubi* ;
: n*u ( n u -- u ) swap u*n ;
: u/n ( u n -- u ) dup 2array [ /f ] [ * abs ] ubi* ;
: n/u ( n u -- u ) [ dup 2array ] dip [ /f ] [ * abs ] ubi* ;
: u*  ( u u -- u ) [ * ] (u*) ;
: u/  ( u u -- u ) [ /f ] (u*) ;

:: u^n ( u n -- u )
    u first2 :> ( v1 s1 )
    v1 n ^ >rect drop :> val
    val n * s1 v1 /f * abs :> sig
    val sig 2array ;

<PRIVATE

: uncertain-demo ( -- )
    { 100 1.1 } { 200 2.2 } u- 2.0 u^n
    { 50 1.2 } { 100 2.3 } u- 2.0 u^n u+ 0.5 u^n . ;

PRIVATE>

MAIN: uncertain-demo
