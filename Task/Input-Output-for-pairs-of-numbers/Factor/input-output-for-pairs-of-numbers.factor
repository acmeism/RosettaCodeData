USING: io math.parser prettyprint sequences splitting ;
IN: rosetta-code.pair-output

: process-line ( str -- n )
    " " split [ string>number ] map-sum ;
: main ( -- ) lines 1 tail [ process-line ] map [ . ] each ;

MAIN: main
