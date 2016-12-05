/*REXX program demonstrates   Jensen's device   (via call subroutine, and args by name).*/
numeric digits 90                                /*use 90 decimal digits (9 is default).*/
say sum( 'i',   "1",   '100',   "1/i" )          /*invoke  SUM  (100th harmonic number).*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sum:  procedure;   parse arg j,start,finish,exp;              $=0

      interpret  'do'    j    "="   start   'to'   finish";   $=$+"    exp    ';   end'
             /*  ────    ═    ───   ═════   ────   ══════──────────    ═══    ───────── */
             /*   lit   var   lit    var     lit     var   literal     var     literal  */

      return $
