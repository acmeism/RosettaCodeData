/*REXX program simulates a  metronome  (with sound),  PC/REXX only.     */
parse arg bpm bpb dur tockf tockd tickf tickd .
if bpm==''  |  bpm==',' then bpm=72    /*number of beats per minute.    */
if bpb==''  |  bpb==',' then bpb= 4    /*number of beats per bar.       */
if dur==''  |  dur==',' then dur= 5    /*duration of run in seconds.    */
if tockf==''|tockf==',' then tockf=400 /*frequency of tock sound in HZ. */
if tockd==''|tockd==',' then tockd=.02 /*duration  of tock sound in secs*/
if tickf==''|tickf==',' then tickf=600 /*frequency of tick sound in HZ. */
if tickd==''|tickd==',' then tickd=.01 /*duration  of tick sound in secs*/
call time 'R'                          /*reset the REXX elapsed timer.  */
bt=1/bpb                               /*calculate a tock-time interval.*/

  do until et>=dur;    et=time('E')    /*process tick-tocks for duration*/
  call sound tockf,tockd               /*sound a beep for the "TOCK".   */
  es=et+1                              /*bump the elapsed time limiter. */
  ee=et+bt
                          do until time('E')>=es;   e=time('E')
                          if e<ee then iterate          /*time for tock?*/
                          call sound tickf,tickd        /*sound a  tick.*/
                          ee=ee+bt                      /*bump tock time*/
                          end    /*until time('E')≥es*/
  end   /*until et≥dur*/
