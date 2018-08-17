/*REXX program solves a   (Pascal's)   "Pyramid of Numbers"   puzzle given four values. */
                              /*╔══════════════════════════════════════════════════╗
                                ║                                     answer       ║
                                ║                     mid            /             ║
                                ║                        \          /              ║
                                ║                         \       151              ║
                                ║                          \   ααα  ααα            ║
                                ║                           40   ααα   ααα         ║
                                ║                         ααα  ααα  ααα  ααα       ║
                                ║                       x    11    y    4    z     ║
                                ║                           /            \         ║
                                ║                          /              \        ║
                                ║                         /                \       ║
                                ║ Find:  x  y  z         b                  d      ║
                                ╚══════════════════════════════════════════════════╝*/
   do #=2;  _=sourceLine(#)                      /* [↓]  this DO loop shows (above) box.*/
   if pos('#',_)\==0  then leave                 /*only display  up to  the above line. */
   say sourceLine(#)                             /*display one line of the above box.   */
   end   /*#*/                                   /* [↑]  this is one cheap way for doc. */
parse arg  b  d  mid  answer .                   /*obtain optional variables from the CL*/
if     b=='' |      b==","  then      b=  11     /*Not specified?  Then use the default.*/
if     d=='' |      d==","  then      d=   4     /* "      "         "   "   "     "    */
if    mid='' |    mid==","  then    mid=  40     /* "      "         "   "   "     "    */
if answer='' | answer==","  then answer= 151     /* "      "         "   "   "     "    */
   pad= left('', 15)                             /*used for inserting spaces in output. */
   big= answer - 4*b - 4*d                       /*calculate big   number less constants*/
middle= mid - 2*b                                /*    "    middle    "     "      "    */
say
   do x  =-big  to big
     do y=-big  to big
     if x+y\==middle   then iterate              /*40 = x+2B+Y   ──or──   40-2*11 = x+y */
         do z=-big  to big
         if z  \==  y - x   then iterate         /*z has to equal y-x  (y=x+z)    */
         if x+y*6+z == big  then say pad  'x = '   x   pad   "y = "   y   pad   'z = '   z
         end   /*z*/
     end       /*y*/
   end         /*x*/                             /*stick a fork in it,  we're all done. */
