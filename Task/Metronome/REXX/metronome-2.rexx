/*REXX program simulates a  metronome  (with sound).    Regina REXX only.               */
parse arg bpm bpb dur tockf tockd tickf tickd .  /*obtain optional arguments from the CL*/
if   bpm=='' |   bpm==","  then   bpm= 72        /*the number of  beats  per minute.    */
if   bpb=='' |   bpb==","  then   bpb=  4        /* "    "     "    "     "   bar.      */
if   dur=='' |   dur==","  then   dur=  5        /*duration  of the  run         in secs*/
if tockf=='' | tockf==","  then tockf=400        /*frequency  "  "   tock  sound  " HZ. */
if tockd=='' | tockd==","  then tockd= 20        /*duration   "  "     "     "    " msec*/
if tickf=='' | tickf==","  then tickf=600        /*frequency  "  "   tick    "    " HZ. */
if tickd=='' | tickd==","  then tickd= 10        /*duration   "  "     "     "    " msec*/
call time 'Reset'                                /*reset the REXX elapsed timer.        */
bt=1/bpb                                         /*calculate a   tock─time   interval.  */

  do until et>=dur;     et=time('Elasped')       /*process  tick-tocks  for the duration*/
  call beep tockf, tockd                         /*sound a beep for the  "TOCK".        */
  es=et+1                                        /*bump the elapsed time  "limiter".    */
  $t=et+bt
                        do until e>=es;        e=time('Elapsed')
                        if e<$t then iterate                       /*time for tock?     */
                        call beep tickf, tickd                     /*sound a  "tick".   */
                        $t=$t+bt                                   /*bump the TOCK time.*/
                         end   /*until e≥es*/
  end   /*until et≥dur*/
                                                 /*stick a fork in it,  we're all done. */
