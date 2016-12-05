/*REXX program  creates and displays  an  ASCII art  version of the   Yin-Yang   symbol.*/
parse arg s1 s2 .                                /*obtain optional arguments from the CL*/
if s1=='' | s1==","  then s1=17                  /*Not defined?   Then use the default. */
if s2=='' | s2==","  then s2= 8                  /* "      "        "   "   "     "     */
if s1>0              then call YinYang  s1       /*create and display the 1st Yin-Yang. */
if s2>0              then call YinYang  s2       /*   "    "    "      "  2nd    "      */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
in@:       procedure; parse arg cy,r,x,y;        return x**2 + (y-cy)**2  <=  r**2
big@:      /*in big         circle.*/            return in@( 0,      r,    x,  y )
semi@:     /*in semi        circle.*/            return in@( r/2,    r/2,  x,  y )
sBK@:      /*in small black circle.*/            return in@( r/2,    r/6,  x,  y )
sWH@:      /*in small white circle.*/            return in@( 0-r/2,  r/6,  x,  y )
BK_semi@:  /*in black semi  circle.*/            return in@( 0-r/2,  r/2,  x,  y )
/*──────────────────────────────────────────────────────────────────────────────────────*/
YinYang: procedure; parse arg r;  mY=1;  mX=2    /*scale multiplier for the  X, Y  axis.*/
         WH='·';    BL="Θ";   zz=' '             /*define some symbol shading (glyphs). */

               do   sy=+r*mY  by -1  while sy >= -r*mY;  $=     /*$: is the output line.*/
                 do sx=-r*mX  by +1  while sx <= +r*mX;  x=sx/mX;          y=sy/mY
                 if big@() then if semi@()  then if sBK@() then $=$||BL
                                                           else $=$||WH
                                            else if BK_semi@() then if sWH@() then $=$||WH
                                                                              else $=$||BL
                                                               else if x<0 then $=$||WH
                                                                           else $=$||BL
                           else $=$ || zz
                 end   /*sy*/
               say $                             /*display a single line of the symbol. */
               end     /*sx*/
         return
