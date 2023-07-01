/*REXX program sorts a list of things (or items) using the  patience sort  algorithm.   */
parse arg xxx;     say ' input: '      xxx       /*obtain a list of things from the C.L.*/
n= words(xxx);     #= 0;       !.= 1             /*N:  # of things;  #:  number of piles*/
@.=                                              /* [↓]  append or create a pile  (@.j) */
   do i=1  for n;              q= word(xxx, i)   /* [↓]  construct the piles of things. */
                do j=1  for #                    /*add the   Q   thing (item) to a pile.*/
                if q>word(@.j,1)  then iterate   /*Is this item greater?   Then skip it.*/
                @.j= q  @.j;           iterate i /*add this item to the top of the pile.*/
                end   /*j*/                      /* [↑]  find a pile, or make a new pile*/
   #= # + 1                                      /*increase the pile count.             */
   @.#= q                                        /*define a new pile.                   */
   end                /*i*/                      /*we are done with creating the piles. */
$=                                               /* [↓]   build a thingy list from piles*/
   do k=1  until  words($)==n                    /*pick off the smallest from the piles.*/
   _=                                            /*this is the smallest thingy so far···*/
          do m=1  for  #;     z= word(@.m, !.m)  /*traipse through many piles of items. */
          if z==''  then iterate                 /*Is this pile null?    Then skip pile.*/
          if _==''  then _= z                    /*assume this one is the low pile value*/
          if _>=z   then do;  _= z;  p= m;  end  /*found a low value in a pile of items.*/
          end   /*m*/                            /*the traipsing is done, we found a low*/
   $= $ _                                        /*add to the output thingy  ($)  list. */
   !.p= !.p + 1                                  /*bump the thingy pointer in pile  P.  */
   end          /*k*/                            /* [↑]  each iteration finds a low item*/
                                                 /* [↓]  string  $  has a leading blank.*/
say 'output: '       strip($)                    /*stick a fork in it,  we're all done. */
