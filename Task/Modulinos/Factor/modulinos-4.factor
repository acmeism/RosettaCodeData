#! /usr/bin/env factor

INCLUDING: scriptedmain ;
USING: io math.parser ;
IN: test

: main ( -- ) meaning-of-life "Test: The meaning of life is " write number>string print ;

MAIN: main
