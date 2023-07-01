USING: kernel io accessors strings math sequences locals
       io.streams.string multiline prettyprint ;

IN: strip-block-comments

TUPLE: comment-state
       { is-in-comment initial: f }
       { delim-start string initial: "/*" }
       { delim-end string initial: "*/" }
       { chars-matched integer initial: 0 } ;

: set-delims ( cmnt-st start end -- cmnt-st )
  [ >>delim-start ] dip
  >>delim-end ;

: target-delim ( cmnt-st -- string )
  dup is-in-comment>>
  [ delim-end>> ]
  [ delim-start>> ] if ;

: target-char ( cmnt-st -- ch )
  dup chars-matched>> swap ! ( cmnt-st -- n cmnt-st )
  target-delim nth ;

: got-delim? ( cmnt-st -- ? )
  [ target-delim length ] keep
  chars-matched>> <= ;

: update-is-in-comment ( cmnt-st -- cmnt-st )
  dup got-delim?
  [ [ not ] change-is-in-comment 0 >>chars-matched ]
  when ;

: matched-chars ( cmnt-st -- string )
  [ target-delim ] [ chars-matched>> ] bi
  0 swap rot <slice> ;

:: process-char ( cmnt-st ch -- cmnt-st )
  cmnt-st update-is-in-comment
  target-char ch =
  [
     cmnt-st [ 1 + ] change-chars-matched
     update-is-in-comment
  ]
  [
    cmnt-st is-in-comment>>
    [ cmnt-st matched-chars >string write ch write1 ] unless
    cmnt-st
  ] if ;

: process-string ( cmnt-st string -- cmnt-st )
  [ process-char ] each ;

: strip-block-comments ( string -- string )
  [ comment-state new swap process-string drop ]
  with-string-writer ;

: strip-block-comments-with-delims ( string start end -- string )
  [ comment-state new -rot set-delims swap process-string drop ] with-string-writer ;

CONSTANT: sample-text [[
  /**
   * Some comments
   * longer comments here that we can parse.
   *
   * Rahoo
   */
   function subroutine() {
    a = /* inline comment */ b + c ;
   }
   /*/ <-- tricky comments */

   /**
    * Another comment.
    */
    function something() {
    }
]]

: test-strip-block-comments ( -- )
  sample-text strip-block-comments write
  "foo(bar)" "(" ")" strip-block-comments-with-delims "foo" assert= ;

MAIN: test-strip-block-comments
