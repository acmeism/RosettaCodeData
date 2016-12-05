/*REXX program implements Langton's ant walk and displays the ant's path (finite field).*/
parse arg dir char seed .                        /*obtain optional arguments from the CL*/
if datatype(seed, 'W')   then call random ,,seed /*Integer? Then use it as a RANDOM SEED*/
if  dir=='' |  dir==","  then dir=random(1, 4)   /*ant is facing a random direction,    */
if char=='' | char==","  then char= '#'          /*binary colors:   0≡white,  1≡black.  */
parse value scrSize() with sd        sw .        /*obtain the terminal's depth and width*/
                           sd=sd-6;  sw=sw-1     /*adjust for terminal's useable area.  */
x=1000000    ;  y=1000000                        /*start ant's walk in middle of nowhere*/
$.=1;  $.0=4 ;  $.2=2;   $.3=3;   $.4=4          /*    1≡north  2≡east  3≡south  4≡west.*/
@.=0         ;  minx=x; miny=y;   maxx=x; maxy=y /*define stem array, default: all white*/
                                                 /* [↓]  ant walks hither and thither.  */
     do steps=1  until (maxx-miny>sw) | (maxy-miny>sd)  /*'til the ant is out─of─bounds.*/
     black=@.x.y;      @.x.y= \ @.x.y            /*invert (flip)  ant's cell color code.*/
     if black  then dir=dir-1                    /*if cell color was black,  turn  left.*/
               else dir=dir+1                    /* "   "    "    "  white,  turn right.*/
     dir=$.dir                                   /*possibly adjust for under/over.      */
               select                            /*ant walks the direction it's facing. */
               when dir==1  then y= y + 1        /*is ant walking north?  Then go up.   */
               when dir==2  then x= x + 1        /* "  "     "     east?    "  "  right.*/
               when dir==3  then y= y - 1        /* "  "     "    south?    "  "  down. */
               when dir==4  then x= x - 1        /* "  "     "     west?    "  "  left. */
               end   /*select*/
     minx=min(minx, x);     maxx=max(maxx, x)    /*find the minimum and maximum of  X.  */
     miny=min(miny, y);     maxy=max(maxy, y)    /*  "   "     "     "     "     "  Y.  */
     end             /*steps*/
                                                 /*finished walking, it's out-of-bounds.*/
say center(" Langton's ant walked "      steps       ' steps. ', 79, "─")
@.1000000.1000000='█'                            /*show the ant's initial starting point*/
@.x.y=            '∙'                            /*show where the ant went out-of-bounds*/
                                                 /* [↓]  show Langton's ant's trail.    */
     do    y=maxy  to miny  by -1;  _=           /*display a single  row  of cells.     */
        do x=minx  to maxx;         _=_ || @.x.y /*build a cell row for the display.    */
        end   /*x*/
     _=strip( translate(_, char, 10),  'T')      /*color the cells:   black  or  white. */
     if _\==''  then say _                       /*display line (strip trailing blanks).*/
     end      /*y*/                              /*stick a fork in it,  we're all done. */
