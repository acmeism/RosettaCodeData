/*REXX program times the generation of 100 frames of random black&white image.*/
parse arg sw sd im .                   /*obtain optional args from the C.L.   */
if sw==',' | sw==''  then sw=320       /*SW  specified?  No, then use default.*/
if sd==',' | sd==''  then sd=240       /*SD       "       "    "   "      "   */
if im==',' | im==''  then im=100       /*IM       "       "    "   "      "   */
call time 'R'                          /*reset the REXX elapsed (clock) timer.*/
              do frame=1  for im       /*generate   IM    number of images.   */
              call genFrame sw,sd      /*generate single image of size SW x SD*/
              /* say frame */          /*do (or don't) display the frame num. */
              end   /*frame*/          /*generate, but don't display the image*/
                                       /*measures  ↓  elapsed time in seconds.*/
say 'The average frames/second: '  format(im/time("E"),,2)    /*show FPS stat.*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
genFrame:  parse arg x,y;         @.0='ff000000'x              /*hex: black.  */
                                  @.1='ffffffff'x              /*hex: white.  */
$=                                                             /*nullify image*/
             do y;  _=                                         /*nullify a row*/
                           do x;  ?=random(0,1);  _=_ || @.?   /*black │ white*/
                           end   /*x*/
             $=$ || _                                          /*append to $. */
             end                 /*y*/
return
