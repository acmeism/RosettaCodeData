#! /usr/bin/env factor

USING: io math.parser ;
IN: scriptedmain

: meaning-of-life ( -- n ) 42 ;

: main ( -- ) meaning-of-life "Main: The meaning of life is " write number>string print ;

MAIN: main
