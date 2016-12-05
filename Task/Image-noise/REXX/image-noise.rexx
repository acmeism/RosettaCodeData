/*REXX program times (elapsed) the generation of 100 frames of random black&white image.*/
parse arg sw sd im .                             /*obtain optional args from the C.L.   */
if sw=='' | sw==","  then sw=320                 /*SW  specified?  No, then use default.*/
if sd=='' | sd==","  then sd=240                 /*SD      "        "    "   "      "   */
if im=='' | im==","  then im=100                 /*IM      "        "    "   "      "   */
call time 'R'                                    /*reset the REXX elapsed (clock) timer.*/
              do   im                            /*generate    IM     number of images. */
              call genFrame  sw, sd              /*generate single image of size SW x SD*/
              /*■■■ display frame here ■■■*/     /*do (or don't) display the frame num. */
              end   /*im*/                       /*generate, but don't display the image*/
                                                 /*measures  ↓  elapsed time in seconds.*/
say 'The average frames/second: '    format(im/time("E"), , 2)     /*show frames/second.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
genFrame:  parse arg x,y;   @.0= 'ff000000'x                   /*hex: the color  black. */
                            @.1= 'ffFFffFF'x                   /* "    "    "    white. */
           $=                                                  /*nullify image string.  */
                  do y;  _=                                    /*nullify an output row. */
                            do x;  ?=random(0,1);  _=_ || @.?  /*color is black │ white.*/
                            end   /*x*/                        /* [↑]  build a whole row*/
                  $=$ || _                                     /*append row to $ string.*/
                  end             /*y*/                        /* [↑]  build the image. */
           return
