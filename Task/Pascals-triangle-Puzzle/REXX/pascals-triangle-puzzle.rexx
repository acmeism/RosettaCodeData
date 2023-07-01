/*REXX program solves a   (Pascal's)   "Pyramid of Numbers"   puzzle given four values. */
      /* ╔══════════════════════════════════════════════════╗
         ║                             answer               ║
         ║                            /                     ║
         ║              mid          /                      ║
         ║                 \       151                      ║
         ║                  \   ααα   ααα                   ║
         ║                   40    ααα   ααα                ║
         ║               ααα   ααα   ααα   ααα              ║
         ║              x    11     y     4     z           ║
         ║                  /              \                ║
         ║ find:           /                \               ║
         ║ x y z          b                  d              ║
         ╚══════════════════════════════════════════════════╝ */
   do #=2;     _= sourceLine(#);  n= pos('_', _) /* [↓]  this DO loop shows (above) box.*/
   if n\==0  then leave;             say _       /*only display  up to  the above line. */
   end   /*#*/;                      say         /* [↑]  this is a way for in─line doc. */
parse arg  b  d  mid  answer  .                  /*obtain optional variables from the CL*/
if     b=='' |      b==","  then      b=  11     /*Not specified?  Then use the default.*/
if     d=='' |      d==","  then      d=   4     /* "      "         "   "   "     "    */
if    mid='' |    mid==","  then    mid=  40     /* "      "         "   "   "     "    */
if answer='' | answer==","  then answer= 151     /* "      "         "   "   "     "    */
                      big= answer - 4*b - 4*d    /*calculate  BIG  number less constants*/
   do      x=-big  to big
     do    y=-big  to big
     if x+y\==mid - 2*b  then iterate            /*40 = x+2B+Y   ──or──   40-2*11 = x+y */
        do z=-big  to big
        if z \== y - x   then iterate            /*Z  has to equal   Y-X       (Y= X+Z) */
        if x+y*6+z==big  then say right('x =', n)  x  right("y =",n)  y  right('z =',n)  z
        end   /*z*/
     end      /*y*/
   end        /*x*/                              /*stick a fork in it,  we're all done. */
