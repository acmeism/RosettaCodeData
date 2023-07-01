/*REXX program simulates a visual (textual)  metronome  (with no sound).                */
parse arg bpm bpb dur .                          /*obtain optional arguments from the CL*/
if bpm=='' | bpm==","  then bpm=72               /*the number of  beats  per minute.    */
if bpb=='' | bpb==","  then bpb= 4               /* "     "    "    "     "   bar.      */
if dur=='' | dur==","  then dur= 5               /*duration of the  run  in seconds.    */
call time 'Reset'                                /*reset the REXX elapsed timer.        */
bt=1/bpb                                         /*calculate a   tock-time   interval.  */

  do until et>=dur;    et=time('Elasped')        /*process  tick-tocks  for the duration*/
  say; call charout ,'TICK'                      /*show the first tick for the period.  */
  es=et+1                                        /*bump the elapsed time  "limiter".    */
  $t=et+bt
                        do until e>=es;        e=time('Elapsed')
                        if e<$t then iterate                       /*time for tock?     */
                        call charout , ' tock'                     /*show a  "tock".    */
                        $t=$t+bt                                   /*bump the TOCK time.*/
                         end   /*until e≥es*/
  end   /*until et≥dur*/
                                                 /*stick a fork in it,  we're all done. */
