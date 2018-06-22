/*REXX program  sorts  and displays  a  stemmed array  using the  comb sort  algorithm. */
call gen;                        w=length(#)     /*generate the  @  array elements.     */
call show       'before sort'                    /*display the  before  array elements. */
     say  copies('▒', 60)                        /*display a separator line  (a fence). */
call combSort  #                                 /*invoke the comb sort (with # entries)*/
call show       ' after sort'                    /*display the   after  array elements. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
combSort: procedure expose @.;   parse arg N     /*N:  is the number of  @  elements.   */
          g=N - 1                                /*G:  is the gap between the sort COMBs*/
                  do  until g<=1 & done;  done=1 /*assume sort is done  (so far).       */
                  g=g * 0.8  % 1                 /*equivalent to:   g=trunc( g / 1.25)  */
                  if g==0  then g=1              /*handle case of the gap is too small. */
                      do j=1  until $ >= N;    $=j + g       /*$:  temp index variable. */
                      if @.j > @.$  then do;   _=@.j;    @.j=@.$;   @.$=_;   done=0;   end
                      end   /*j*/
                  end       /*until*/            /* [↑]  swap two elements in the array.*/
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen:      @.   =                            ;       @.12 = "dodecagon         12"
          @.1  = '----polygon---  sides'    ;       @.13 = "tridecagon        13"
          @.2  = '============== ======='   ;       @.14 = "tetradecagon      14"
          @.3  = 'triangle           3'     ;       @.15 = "pentadecagon      15"
          @.4  = 'quadrilateral      4'     ;       @.16 = "hexadecagon       16"
          @.5  = 'pentagon           5'     ;       @.17 = "heptadecagon      17"
          @.6  = 'hexagon            6'     ;       @.18 = "octadecagon       18"
          @.7  = 'heptagon           7'     ;       @.19 = "enneadecagon      19"
          @.8  = 'octagon            8'     ;       @.20 = "icosagon          20"
          @.9  = 'nonagon            9'     ;       @.21 = "hectogon         100"
          @.10 = 'decagon           10'     ;       @.22 = "chiliagon       1000"
          @.11 = 'hendecagon        11'     ;       @.23 = "myriagon       10000"
                   do #=1  while  @.#\=='';  end;   #=#-1  /*find how many elements in @*/
          return                                 /* [↑]  adjust # because of the DO loop*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:     do k=1  for #; say right('element',15) right(k,w)  arg(1)":"  @.k;  end;  return
