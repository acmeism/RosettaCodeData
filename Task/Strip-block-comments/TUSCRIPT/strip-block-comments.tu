$$ MODE DATA
$$ script=*
  /**
   * Some comments
   * longer comments here that we can parse.
   *
   * Rahoo
   */
   function subroutine() {
    a = /* inline comment */ b + c ;
   }
   /*/ <-- tricky comments  */

   /**
    * Another comment.
    */
    function something() {
    }
$$ MODE TUSCRIPT
ERROR/STOP CREATE ("testfile",SEQ-E,-std-)
ERROR/STOP CREATE ("destfile",SEQ-E,-std-)
FILE "testfile" = script
BUILD S_TABLE commentbeg=":/*:"
BUILD S_TABLE commentend=":*/:"

ACCESS t: READ/STREAM "testfile" s.z/u,a/commentbeg+t+e/commentend,typ
ACCESS d: WRITE/STREAM "destfile" s.z/u,a+t+e
LOOP
READ/EXIT t
IF (typ==3) CYCLE
t=SQUEEZE(t)
WRITE/ADJUST d
ENDLOOP
ENDACCESS/PRINT t
ENDACCESS/PRINT d
d=FILE("destfile")
TRACE *d
