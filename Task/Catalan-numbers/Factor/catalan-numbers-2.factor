USING: kernel math prettyprint sequences ;

: next ( seq -- newseq )
  [ ] [ last ] [ length ] tri
  [ 2 * 1 - 2 * ] [ 1 + ] bi /
  * suffix ;

: Catalan ( n -- seq )  V{ 1 } swap 1 - [ next ] times ;

15 Catalan .
