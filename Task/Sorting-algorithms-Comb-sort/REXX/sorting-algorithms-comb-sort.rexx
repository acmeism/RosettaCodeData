/*REXX program  sorts  and displays  a  stemmed array  using the  comb sort  algorithm. */
call gen                                         /*generate the   @   array elements.   */
call show    'before sort'                       /*display the  before  array elements. */
                            say  copies('▒', 60) /*display a separator line  (a fence). */
call combSort    #                               /*invoke the comb sort (with # entries)*/
call show    ' after sort'                       /*display the   after  array elements. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
combSort: procedure expose @.;   parse arg N     /*N:  is the number of  @  elements.   */
          g= N-1                                 /*G:  is the gap between the sort COMBs*/
                 do  until g<=1 & done;  done= 1 /*assume sort is done  (so far).       */
                 g= g * 0.8  % 1                 /*equivalent to:   g= trunc( g / 1.25) */
                 if g==0  then g= 1              /*handle case of the gap is too small. */
                    do j=1  until $>=N;  $= j+g  /*$:     a temporary index  (pointer). */
                    if @.j>@.$  then do;   _= @.j;    @.j= @.$;   @.$= _;   done= 0;   end
                    end   /*j*/
                 end     /*until*/               /* [↑]  swap two elements in the array.*/
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen: @.=;     @.1  = '----polygon---  sides'  ;              @.12 = "dodecagon         12"
              @.2  = '============== =======' ;              @.13 = "tridecagon        13"
              @.3  = 'triangle           3'   ;              @.14 = "tetradecagon      14"
              @.4  = 'quadrilateral      4'   ;              @.15 = "pentadecagon      15"
              @.5  = 'pentagon           5'   ;              @.16 = "hexadecagon       16"
              @.6  = 'hexagon            6'   ;              @.17 = "heptadecagon      17"
              @.7  = 'heptagon           7'   ;              @.18 = "octadecagon       18"
              @.8  = 'octagon            8'   ;              @.19 = "enneadecagon      19"
              @.9  = 'nonagon            9'   ;              @.20 = "icosagon          20"
              @.10 = 'decagon           10'   ;              @.21 = "hectogon         100"
              @.11 = 'hendecagon        11'   ;              @.22 = "chiliagon       1000"
                                                             @.23 = "myriagon       10000"
                         do #=1  while  @.#\=='';  end    /*find how many elements in @ */
      #= #-1;     w= length(#);           return          /*adjust # because of DO loop.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:     do k=1  for #; say right('element',15) right(k,w)  arg(1)":"  @.k;  end;  return
