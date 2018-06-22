/*REXX program sorts a stemmed array (numbers or chars) using the  merge─sort algorithm.*/
@.=;                 @.1 = '---The seven deadly sins---'
                     @.2 = '==========================='   ;      @.6 = "envy"
                     @.3 = 'pride'                         ;      @.7 = "gluttony"
                     @.4 = 'avarice'                       ;      @.8 = "sloth"
                     @.5 = 'wrath'                         ;      @.9 = "lust"
       do #=1  until @.#=='';  end;    #=#-1     /*# ≡ the number of entries in @ array.*/
call show@     'before sort'                     /*show the   "before"  array elements. */
     say copies('▒', 75)                         /*display a separator line to the term.*/
call mergeSort      #                            /*invoke the  merge sort  for the array*/
call show@     ' after sort'                     /*show the    "after"  array elements. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
mergeSort: procedure expose @.;        call mergeTo@ 1,arg(1);             return
show@: do j=1 for #; say right('element',20) right(j,length(#)) arg(1)":" @.j; end; return
/*──────────────────────────────────────────────────────────────────────────────────────*/
mergeTo@:  procedure expose @. !.;     parse arg L,n;     if n==1  then return;      h=L+1
           if n==2  then do;  if @.L>@.h  then do; _=@.h; @.h=@.L; @.L=_; end; return; end
           m=n % 2                                     /* [↑]  handle case of two items.*/
           call mergeTo@ L+m,n-m                       /*divide items  to the left   ···*/
           call mergeTo! L,m,1                         /*   "     "     "  "  right  ···*/
           i=1;   j=L+m;            do k=L  while k<j  /*whilst items on right exist ···*/
                                    if j==L+n | !.i<=@.j  then do;  @.k=!.i;  i=i+1;   end
                                                          else do;  @.k=@.j;  j=j+1;   end
                                    end   /*k*/
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
mergeTo!:  procedure expose @. !.; parse arg L,n,T; if n==1  then do; !.T=@.L; return; end
           if n==2  then do;   h=L+1;    q=T+1;    !.q=@.L;    !.T=@.h;        return; end
           m=n % 2                                     /* [↑]  handle case of two items.*/
           call mergeTo@ L,m                           /*divide items  to the left   ···*/
           call mergeTo! L+m,n-m,m+T                   /*   "     "     "  "  right  ···*/
           i=L;   j=m+T;            do k=T  while k<j  /*whilst items on left exist  ···*/
                                    if j==T+n | @.i<=!.j  then do;  !.k=@.i;  i=i+1;   end
                                                          else do;  !.k=!.j;  j=j+1;   end
                                    end   /*k*/
           return
