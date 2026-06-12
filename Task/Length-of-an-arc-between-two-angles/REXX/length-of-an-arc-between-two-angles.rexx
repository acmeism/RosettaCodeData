/*REXX program calculates the  length of an arc  between two angles (stated in degrees).*/
parse arg radius angle1 angle2 .                 /*obtain optional arguments from the CL*/
if radius=='' | radius==","  then radius=  10    /*Not specified?  Then use the default.*/
if angle1=='' | angle1==","  then angle1=  10    /* "      "         "   "   "     "    */
if angle2=='' | angle2==","  then angle2= 120    /* "      "         "   "   "     "    */

say '     circle radius = '   radius
say '           angle 1 = '   angle1"º"          /*angles may be  negative  or  >  360º.*/
say '           angle 2 = '   angle2"º"          /*   "    "   "      "      "  "   "   */
say
say '        arc length = '   arcLength(radius, angle1, angle2)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
arcLength: procedure; parse arg r,a1,a2; #=360; return (#-abs(a1//#-a2//#)) * pi()/180 * r
/*──────────────────────────────────────────────────────────────────────────────────────*/
pi:        pi= 3.1415926535897932384626433832795;  return pi   /*use 32 digs (overkill).*/
