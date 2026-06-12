USING: accessors kernel math math.parser strings ;

PREDICATE: numeric-string < string string>number >boolean ;
TUPLE: pseudo-number { value union{ number numeric-string } } ;
C: <pseudo-number> pseudo-number   ! constructor

5.245 <pseudo-number>   ! ok
"-17"   >>value         ! ok
"abc42" >>value         ! error
