/*REXX program sorts a (stemmed) array using the  merge─sort  algorithm.*/
call gen@;             w=length(#)     /*generate an array (@.) of items*/
call show@     'before sort'           /*show the before array elements.*/
call mergeSort  #                      /*invoke the merge sort for array*/
call show@     ' after sort'           /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@:           @.  =                  /*assign default value for @ stem*/
                @.1 = '---The seven deadly sins---'   /*pick a favorite.*/
                @.2 = '==========================='
                @.3 = 'pride'
                @.4 = 'avarice'
                @.5 = 'wrath'
                @.6 = 'envy'
                @.7 = 'gluttony'
                @.8 = 'sloth'
                @.9 = 'lust'
  do #=1  while @.#\==''; end;   #=#-1 /*find the number of entries in @*/
return
/*──────────────────────────────────MERGESORT subroutine────────────────*/
mergeSort:  procedure expose @.;    call mergeTo@ 1,arg(1);         return
/*──────────────────────────────────MERGETO@ subroutine─────────────────*/
mergeTo@: procedure expose @. !.;   parse arg L,n ;   if n==1  then return
if n==2  then do;   h=L+1              /*handle special case of 2 items.*/
              if @.L>@.h  then do;   _=@.h;   @.h=@.L;   @.L=_;   end
              return
              end
m=n%2                                  /*cut  N  in half  (integer div.)*/
call mergeTo@ L+m,n-m                  /*divide items  to the left   ···*/
call mergeTo! L,m,1                    /*   "     "     "  "  right  ···*/
i=1;   j=L+m;           do k=L  while k<j     /*whilst items on right···*/
                        if j==L+n | !.i<=@.j  then do; @.k=!.i; i=i+1; end
                                              else do; @.k=@.j; j=j+1; end
                        end   /*k*/
return
/*──────────────────────────────────MERGETO! subroutine─────────────────*/
mergeTo!:   procedure expose @. !.;      parse arg L,n,_
if n==1  then do; !._=@.L; return; end /*handle special case of 1 item. */
if n==2  then do                       /*   "      "      "   " 2 items.*/
              h=L+1;      q=1+_
              if @.L>@.h  then  do;   q=_;   _=q+1;   end
              !._=@.L;    !.q=@.h
              return                   /*done with special case of  N=2.*/
              end
m=n%2                                  /*cut  N  in half  (integer div).*/
call mergeTo@ L,m                      /*divide items  to the left   ···*/
call mergeTo! L+m,n-m,m+_              /*   "     "     "  "  right  ···*/
i=L;   j=m+_;           do k=_  while k<j     /*whilst items on left ···*/
                        if j==_+n | @.i<=!.j  then do; !.k=@.i; i=i+1; end
                                              else do; !.k=!.j; j=j+1; end
                        end   /*k*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: say copies('▒',70);    do j=1  for #;  pad=left('',10)  /*indent.*/
                              say pad  'element'  right(j,w) arg(1)':' @.j
                              end   /*j*/
return
