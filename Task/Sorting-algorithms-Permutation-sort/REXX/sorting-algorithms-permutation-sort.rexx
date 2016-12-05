/*REXX program  sorts and displays  an array  using the  permutation-sort  method.      */
call gen@                                        /*generate the array elements.         */
call show@    'before sort'                      /*show the  before  array elements.    */
say  copies('▒', 70)                             /*show separator line between displays.*/
call permsets     L                              /*generate  items  (!)  permutations.  */
call permSort     L                              /*invoke the permutation sort.         */
call show@    ' after sort'                      /*show the   after  array elements.    */
say; say 'Permutation sort took'     ?     "permutations to find the sorted list."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen@:            @.=; @.1= '---Four_horsemen_of_the_Apocalypse---'
                      @.2= '====================================='
                      @.3= 'Famine───black_horse'
                      @.4= 'Death───pale_horse'
                      @.5= 'Pestilence_[Slaughter]───red_horse'
                      @.6= 'Conquest_[War]───white_horse'
                                                 /* [↓]  also assign to another array.  */
           do L=1  while @.L\==''; @@.L=@.L; end /* [↓]  find number of entries in array*/
      L=L-1                                      /*adjust the number of items by one.   */
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
inOrder:   parse arg q                                    /*see if  Q  list is in order.*/
           _=word(q,1);  do j=2  to words(q);  x=word(q,j)
                         if x<_  then return 0            /*Out of order?   Not sorted. */
                         _=x
                         end   /*j*/
                      do k=1  for #;  _=word(#.?,k);  @.k=@@._;  end  /*k*/
           return 1                                       /*they're all in order finally*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
.permAdd:  #=#+1;     do j=1  for N;   #.#=#.#  !.j;   end  /*j*/;                  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
.permNext: procedure expose !.;    parse arg n,i;    nm=n-1
             do k=nm  by -1  for nm;   kp=k+1
             if !.k<!.kp   then  do;   i=k;   leave;   end
             end   /*k*/
                 do j=i+1  while j<n;  parse value !.j !.n with !.n !.j;  n=n-1;  end
           if i==0 then return 0;              do j=i+1  while !.j<!.i;   end   /*j*/
           parse  value    !.j  !.i    with    !.i  !.j
           return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
permsets:  procedure expose !. # #.;    parse arg n,#.;          #=0
                            do f=1  for n;    !.f=f;   end  /*f*/
           call .permAdd;   do while .permNext(n,0);   call .permAdd;  end  /*while*/
           return #
/*──────────────────────────────────────────────────────────────────────────────────────*/
permSort:             do ?=1  until inOrder($); $=            /*find sorted permutation.*/
                          do m=1  for #;   _=word(#.? ,m);     $=$  @._;    end  /*m*/
                      end   /*?*/
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show@:                do j=1  for L;  say '      element' right(j,length(L)) arg(1)":" @.j
                      end /*j*/                           /* [↑]  display array elements*/
           return
