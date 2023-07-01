USING: kernel math prettyprint sequences ;
IN: rosetta-code.partial-function-application

ALIAS: fs map
: f1   ( n -- m  ) 2 * ;
: f2   ( n -- m  ) dup * ;
: fsf1 ( s -- s' ) [ f1 ] fs ;
: fsf2 ( s -- s' ) [ f2 ] fs ;

{ 0 1 2 3 } [ fsf1 . ] [ fsf2 . ] bi
{ 2 4 6 8 } [ fsf1 . ] [ fsf2 . ] bi
