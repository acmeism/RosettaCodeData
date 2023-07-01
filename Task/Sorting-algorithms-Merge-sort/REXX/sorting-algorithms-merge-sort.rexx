/*REXX pgm sorts a stemmed array (numbers and/or chars) using the  merge─sort algorithm.*/
call init                                        /*sinfully initialize the   @   array. */
call show      'before sort'                     /*show the   "before"  array elements. */
                            say copies('▒', 75)  /*display a separator line to the term.*/
call merge          #                            /*invoke the  merge sort  for the array*/
call show      ' after sort'                     /*show the    "after"  array elements. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
init: @.=;    @.1= '---The seven deadly sins---'  ;    @.4= "avarice"  ;   @.7= 'gluttony'
              @.2= '==========================='  ;    @.5= "wrath"    ;   @.8= 'sloth'
              @.3= 'pride'                        ;    @.6= "envy"     ;   @.9= 'lust'
      do #=1  until @.#==''; end;   #= #-1;   return      /*#:  # of entries in @ array.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: do j=1  for #; say right('element',20) right(j,length(#)) arg(1)":" @.j; end; return
/*──────────────────────────────────────────────────────────────────────────────────────*/
merge: procedure expose @. !.;   parse arg n, L;   if L==''  then do;  !.=;  L= 1;  end
          if n==1  then return;     h= L + 1
          if n==2  then do; if @.L>@.h  then do; _=@.h; @.h=@.L; @.L=_; end; return;  end
          m= n % 2                                     /* [↑]  handle case of two items.*/
          call merge  n-m, L+m                         /*divide items  to the left   ···*/
          call merger m,   L,   1                      /*   "     "     "  "  right  ···*/
          i= 1;                     j= L + m
                     do k=L  while k<j                 /*whilst items on right exist ···*/
                     if j==L+n  |  !.i<=@.j  then do;     @.k= !.i;     i= i + 1;      end
                                             else do;     @.k= @.j;     j= j + 1;      end
                     end   /*k*/
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
merger: procedure expose @. !.;  parse arg n,L,T
           if n==1  then do;  !.T= @.L;                                       return;  end
           if n==2  then do;  h= L + 1;   q= T + 1;  !.q= @.L;    !.T= @.h;   return;  end
           m= n % 2                                    /* [↑]  handle case of two items.*/
           call merge  m,   L                          /*divide items  to the left   ···*/
           call merger n-m, L+m, m+T                   /*   "     "     "  "  right  ···*/
           i= L;                     j= m + T
                     do k=T  while k<j                 /*whilst items on left exist  ···*/
                     if j==T+n  |  @.i<=!.j  then do;     !.k= @.i;     i= i + 1;      end
                                             else do;     !.k= !.j;     j= j + 1;      end
                     end   /*k*/
           return
