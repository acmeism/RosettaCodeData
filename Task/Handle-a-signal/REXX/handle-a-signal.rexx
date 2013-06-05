/*REXX program displays integers until a   Ctrl─C  is pressed, then show*/
/* the number of seconds that have elapsed since start of pgm execution.*/

call time 'E'                          /*reset the REXX elapsed timer.  */
signal on halt                         /*HALT is signaled via a  Ctrl─C.*/

  do j=1                               /*start with 1 and go ye forth.  */
  say right(j,20)                      /*display integer right-justified*/
  t=time('E')                          /*get the elapsed time in seconds*/
              do forever; u=time('E')  /*get the elapsed time in seconds./
              if u<t |,                /* ◄═══ means we passed midnight.*/
                 u>t+.5 then iterate j /* ◄═══ means we passed ½ second.*/
              end   /*forever*/
  end               /*j*/

say 'Program control should never ever get here, said Captain Dunsel.'

/*──────────────────────────────────HALT subroutine─────────────────────*/
halt: say 'program HALTed, it ran for' format(time("E"),,2) 'seconds.'
                                       /*stick a fork in it, we're done.*/
