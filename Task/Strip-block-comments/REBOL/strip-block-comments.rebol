Rebol [
    title: "Rosetta code: Strip block comments"
    file:  %Strip_block_comments.r3
    url:   https://rosettacode.org/wiki/Strip_block_comments
]

strip-comments: function [
    text [string!] "(modified)"
    /with
     comment-start [string!]
     comment-end   [string!]
][
    comment-start: any [comment-start "/*"]
    comment-end:   any [comment-end   "*/"]
    parse text [any [
        to comment-start s: comment-start
        thru comment-end e: (e: remove/part s e) :e
    ]]
    text
]

print strip-comments %{
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
}%
