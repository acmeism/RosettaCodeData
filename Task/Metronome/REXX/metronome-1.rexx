/*REXX program simulates a visual (textual)  metronome  (with no sound).*/
parse arg bpm bpb dur .
if bpm=='' | bpm==','  then bpm=72     /*number of beats per minute.    */
if bpb=='' | bpb==','  then bpb= 4     /*number of beats per bar.       */
if dur=='' | dur==','  then dur= 5     /*duration of run in seconds.    */
call time 'R'                          /*reset the REXX elapsed timer.  */
bt=1/bpb                               /*calculate a tock-time interval.*/

  do until et>=dur;    et=time('E')    /*process tick-tocks for duration*/
  say; call charout ,'TICK'            /*show the first tick for period.*/
  es=et+1                              /*bump the elapsed time limiter. */
  ee=et+bt
                          do until time('E')>=es;   e=time('E')
                          if e<ee then iterate          /*time for tock?*/
                          call charout ,' tock'         /*show a "tock".*/
                          ee=ee+bt                      /*bump tock time*/
                          end    /*until time('E')≥es*/
  end   /*until et≥dur*/
