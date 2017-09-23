/*REXX program  sorts and displays  an array  using the  permutation-sort  method.      */
call gen                                         /*generate the array elements.         */
call show     'before sort'                      /*show the  before  array elements.    */
say  copies('░', 75)                             /*show separator line between displays.*/
call pSort    L                                  /*invoke the permutation sort.         */
call show     ' after sort'                      /*show the   after  array elements.    */
say; say 'Permutation sort took '      ?      " permutations to find the sorted list."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
.pAdd:  #=#+1; do j=1 for N;  #.#=#.#  !.j;  end;   return          /*add a permutation.*/
show:          do j=1 for L; say @e right(j,wL) arg(1)":" translate(@.j,,'_'); end; return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen:    @.=;                            @.1 = '---Four_horsemen_of_the_Apocalypse---'
                                        @.2 = '====================================='
                                        @.3 = 'Famine───black_horse'
                                        @.4 = 'Death───pale_horse'
                                        @.5 = 'Pestilence_[Slaughter]───red_horse'
                                        @.6 = 'Conquest_[War]───white_horse'
        @e=right('element', 15)                          /*literal used for the display.*/
          do L=1  while @.L\=='';  @@.L=@.L;   end;    L=L-1;      wL=length(L);    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
isOrd:  parse arg q                                      /*see if  Q  list is in order. */
        _=word(q, 1);  do j=2  to words(q);  x=word(q, j);  if x<_  then return 0;     _=x
                       end   /*j*/                       /* [↑]  Out of order?   ¬sorted*/
          do k=1  for #;  _=word(#.?, k);  @.k=@@._;  end  /*k*/;  return 1  /*in order.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
.pNext: procedure expose !.;    parse arg n,i;   nm=n-1
                             do k=nm  by -1  for nm;   kp=k+1
                             if !.k<!.kp   then  do;   i=k;   leave;   end
                             end   /*k*/                 /* [↓]  swap two array elements*/
           do j=i+1  while j<n;  parse value  !.j !.n  with  !.n !.j;   n=n-1;  end  /*j*/
        if i==0  then return 0                           /*0:  indicates no more perms. */
           do j=i+1  while !.j<!.i;   end  /*j*/         /*search perm for a lower value*/
        parse  value    !.j  !.i    with    !.i  !.j     /*swap two values in !.  array.*/
        return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
pSort:  parse arg n,#.;  #=0                     /*generate  L  items (!)  permutations.*/
                     do f=1  for n;               !.f=f;        end  /*f*/
        call .pAdd;  do while .pNext(n, 0);       call .pAdd;   end  /*while*/
                     do ?=1  until isOrd($);      $=                        /*find perm.*/
                       do m=1  for #; _=word(#.?, m); $=$ @._;  end  /*m*/  /*build list*/
                     end   /*?*/
        return
