/*REXX program sorts an array using the  permutation-sort  method.      */
call gen@                              /*generate the array elements.   */
call show@     'before sort'           /*show the before array elements.*/
call permsets  L                       /*generate  items!  permutations.*/
call permSort  L                       /*invoke the permutation sort.   */
call show@     ' after sort'           /*show the  after array elements.*/
say; say 'Permutation sort took' ? "permutations to find the sorted list."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: @.  =                            /*assign default value.          */
      @.1 = '---Four_horsemen_of_the_Apocalypse---'
      @.2 = '====================================='
      @.3 = 'Famine───black_horse'
      @.4 = 'Death───pale_horse'
      @.5 = 'Pestilence_[Slaughter]───red_horse'
      @.6 = 'Conquest_[War]───white_horse'
                                       /*[↓] find # of entries in array.*/
       do L=1  while @.L\=='';  @@.L=@.L;  end   /*L*/
L=L-1                                  /*adjust number of items by one. */
return
/*──────────────────────────────────INORDER subroutine──────────────────*/
inOrder: parse arg q                   /*see if list  Q  is in order.   */
_=word(q,1);  do j=2  to words(q);     x=word(q,j)
              if x<_  then return 0    /*Out of order?  Then not sorted.*/
              _=x
              end   /*j*/
  do k=1  for #;  _=word(#.?,k);  @.k=@@._;  end  /*k*/     /*here it is*/
return 1                               /*they're all in order finally.  */
/*──────────────────────────────────PERMSETS subroutine─────────────────*/
permsets: procedure expose !. # #.;    parse arg n,#.;      #=0
                 do f=1  for n;  !.f=f;  end                     /*f*/
call .permAdd                                        /*populate 1st perm*/
                 do while .permNext(n,0);   call .permAdd;  end  /*while*/
return #
.permNext:  procedure expose !.;    parse arg n,i;    nm=n-1
  do k=nm  by -1  for nm;   kp=k+1
  if !.k<!.kp   then  do;   i=k;   leave;   end
  end   /*k*/
      do j=i+1  while j<n;  parse value !.j !.n with !.n !.j;  n=n-1;  end
if i==0 then return 0;              do j=i+1  while !.j<!.i;   end   /*j*/
parse  value    !.j  !.i    with    !.i  !.j
return 1
.permAdd: #=#+1;     do j=1  for N;  #.#=#.# !.j;  end  /*j*/;      return
/*──────────────────────────────────PERMSORT subroutine─────────────────*/
permSort: do ?=1  until inOrder($); $= /*look for the sorted permutation*/
              do m=1  for #;        _=word(#.?,m);    $=$ @._;   end /*m*/
          end   /*?*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@:                do j=1  for L    /* [↓]  display elements in array*/
                      say '      element' right(j,length(L)) arg(1)":" @.j
                      end /*j*/
say copies('■', 70)                    /*show a nice separator line.    */
return
