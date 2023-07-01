USING: accessors kernel ;
IN: rosetta-code.queue-definition

TUPLE: queue head tail ;
TUPLE: node value next ;

: <queue> ( -- queue ) queue new ;
: <node> ( obj -- node ) node new swap >>value ;

: empty? ( queue -- ? ) head>> >boolean not ;

: enqueue ( obj queue -- )
    [ <node> ] dip 2dup dup empty?
    [ head<< ] [ tail>> next<< ] if tail<< ;

: dequeue ( queue -- obj )
    dup empty? [ "Cannot dequeue empty queue." throw ] when
    [ head>> value>> ] [ head>> next>> ] [ head<< ] tri ;
