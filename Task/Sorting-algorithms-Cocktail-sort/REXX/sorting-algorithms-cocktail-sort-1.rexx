/*REXX program sorts an array using the cocktail─sort method,  A.K.A.:  happy hour sort,*/
                                                 /*   bidirectional bubble sort,        */
                                                 /*   cocktail shaker sort, ripple sort,*/
                                                 /*   a selection sort variation,       */
                                                 /*   shuffle sort,  shuttle sort,   or */
                                                 /*   a bubble sort variation.          */
call gen@                                        /*generate some array elements.        */
call show@ 'before sort'                         /*show  unsorted  array elements.      */
     say copies('█', 101)                        /*show a separator line  (a fence).    */
call cocktailSort  #                             /*invoke the cocktail sort subroutine. */
call show@ ' after sort'                         /*show    sorted  array elements.      */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cocktailSort: procedure expose @.;    parse arg N             /*N:  is number of items. */
                     do until done;   done= 1
                         do j=1    for N-1;              jp= j+1
                         if @.j>@.jp  then do;  done=0;  _=@.j;  @.j=@.jp;  @.jp=_;  end
                         end   /*j*/
                     if done  then leave                      /*No swaps done?  Finished*/
                         do k=N-1  for N-1  by -1;       kp= k+1
                         if @.k>@.kp  then do;  done=0;  _=@.k;  @.k=@.kp;  @.kp=_;  end
                         end   /*k*/
                     end       /*until*/
              return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen@: @.=                                        /*assign a default value for the stem. */
      @.1 ='---the 22 card tarot deck (larger deck has 56 additional cards in 4 suits)---'
      @.2 ='==========symbol====================pip======================================'
      @.3 ='the juggler                  ◄───     I'
      @.4 ='the high priestess  [Popess] ◄───    II'
      @.5 ='the empress                  ◄───   III'
      @.6 ='the emperor                  ◄───    IV'
      @.7 ='the hierophant  [Pope]       ◄───     V'
      @.8 ='the lovers                   ◄───    VI'
      @.9 ='the chariot                  ◄───   VII'
      @.10='justice                      ◄───  VIII'
      @.11='the hermit                   ◄───    IX'
      @.12='fortune  [the wheel of]      ◄───     X'
      @.13='strength                     ◄───    XI'
      @.14='the hanging man              ◄───   XII'
      @.15='death  [often unlabeled]     ◄───  XIII'
      @.16='temperance                   ◄───   XIV'
      @.17='the devil                    ◄───    XV'
      @.18='lightning  [the tower]       ◄───   XVI'
      @.18='the stars                    ◄───  XVII'
      @.20='the moon                     ◄─── XVIII'
      @.21='the sun                      ◄───   XIX'
      @.22='judgment                     ◄───    XX'
      @.23='the world                    ◄───   XXI'
      @.24='the fool  [often unnumbered] ◄───  XXII'

            do #=1  until @.#==''; end;  #= #-1  /*find how many entries in the array.  */
      return                                     /* [↑]  adjust for DO loop advancement.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show@: w= length(#);              do j=1  for #      /*#:  is the number of items in @. */
                                  say 'element'    right(j, w)     arg(1)":"    @.j
                                  end   /*j*/        /*     ↑                           */
       return                                        /*     └─────max width of any line.*/
