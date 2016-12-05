import strutils

proc commentStripper(txt; delim: tuple[l,r: string] = ("/*", "*/")): string =
  let i = txt.find(delim.l)
  if i < 0:
    return txt

  result = if i > 0: txt[0 .. <i] else: ""
  let tmp = commentStripper(txt[i+delim.l.len .. txt.high])
  let j = tmp.find(delim.r)
  assert j >= 0
  result &= tmp[j+delim.r.len .. tmp.high]

echo "NON-NESTED BLOCK COMMENT EXAMPLE:"
echo commentStripper("""/**
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
    }""")

echo "\nNESTED BLOCK COMMENT EXAMPLE:"
echo commentStripper("""  /**
   * Some comments
   * longer comments here that we can parse.
   *
   * Rahoo
   *//*
   function subroutine() {
    a = /* inline comment */ b + c ;
   }
   /*/ <-- tricky comments */
   */
   /**
    * Another comment.
    */
    function something() {
    }""")
