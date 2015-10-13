/*REXX program sorts a  stemmed array  using the  comb sort  algorithm.       */
call gen;                 w=length(#)  /*generate the  @  array elements.     */
call show       'before sort'          /*display the  before  array elements. */
say copies('▒',60)                     /*display a separator line  (a fence). */
call combSort   #                      /*invoke the  comb sort.               */
call show       ' after sort'          /*display the   after  array elements. */
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────COMBSORT subroutine───────────────────────*/
combSort: procedure expose @.;  parse arg N  /*N: is number of  @  elements.  */
s=N-1                                        /*S: is the spread between COMBs.*/
       do  until  s<=1 & done;  done=1       /*assume sort is done  (so far). */
       s=trunc(s*.8)                         /*   ÷   is slow,   *  is better.*/
          do j=1  until js>=N;    js=j+s
          if @.j>@.js  then  do;  _=@.j;  @.j=@.js;  @.js=_;  done=0;  end
          end   /*j*/
       end      /*until*/
return
/*──────────────────────────────────GEN subroutine────────────────────────────*/
gen:        @.   =                            ;    @.12 = 'dodecagon         12'
            @.1  = '----polygon---  sides'    ;    @.13 = 'tridecagon        13'
            @.2  = '============== ======='   ;    @.14 = 'tetradecagon      14'
            @.3  = 'triangle           3'     ;    @.15 = 'pentadecagon      15'
            @.4  = 'quadrilateral      4'     ;    @.16 = 'hexadecagon       16'
            @.5  = 'pentagon           5'     ;    @.17 = 'heptadecagon      17'
            @.6  = 'hexagon            6'     ;    @.18 = 'octadecagon       18'
            @.7  = 'heptagon           7'     ;    @.19 = 'enneadecagon      19'
            @.8  = 'octagon            8'     ;    @.20 = 'icosagon          20'
            @.9  = 'nonagon            9'     ;    @.21 = 'hectogon         100'
            @.10 = 'decagon           10'     ;    @.22 = 'chiliagon       1000'
            @.11 = 'hendecagon        11'     ;    @.23 = 'myriagon       10000'
  do #=1  while @.#\==''; end;   #=#-1 /*determine how many entries in @ array*/
return
/*──────────────────────────────────SHOW subroutine───────────────────────────*/
show: do j=1 for #; say '        element' right(j,w) arg(1)":" @.j; end;  return
