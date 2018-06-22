/*REXX program generates all  permutations  of   N   derangements  and  subfactorial #  */
numeric digits 1000                              /*be able to handle large subfactorials*/
parse arg N .;     if N=='' | N==","  then N=4   /*Not specified?  Then use the default.*/
d= derangeSet(N)                                 /*go and build the  derangements  set. */
say d  'derangements for'    N    "items are:"
say
      do i=1  for  d                             /*display the derangements for N items.*/
      say right('derangement', 22)       right(i, length(d) )        '───►'         $.i
      end   /*i*/
say                                              /* [↓]  count and calculate subfact !L.*/
      do L=0  to 2;  d= derangeSet(L)
      say L 'items:  derangement count='right(d, 6)",  !"L'='right( !s(L), 6)
      end   /*L*/
say
say right('!20=' , 22)     !s( 20)
say right('!200=', 22)     !s(200)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
!s:         _=1;      do j=1  for arg(1);  if j//2  then _= j*_  -  1;     else _=j*_  + 1
                      end   /*j*/;                       return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
derangeSet: procedure expose $.;  parse arg x;   $.=;    #=0;   p=x-1
            if x==0  then return 1;  if x==1  then return 0
            @.1=2;  @.2=1                                    /*populate 1st derangement.*/
              do i=3  to x;  @.i=i;  end  /*i*/              /*    "    the rest of 'em.*/
            parse value  @.p  @.x   with   @.x  @.p;   call .buildD x    /*swap & build.*/
                                                                         /*build others.*/
              do while .nextD(x, 0);  call .buildD x;   end;                  return #
/*──────────────────────────────────────────────────────────────────────────────────────*/
.buildD:              do j=1  for arg(1);   if @.j==j  then return;  end
            #=#+1;    do j=1  for arg(1);   $.#= $.# @.j;            end;     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
.nextD:     procedure expose @.;  parse arg n,i

              do k=n-1  by -1  for n-1;  kp=k+1;     if @.k<@.kp  then do; i=k; leave; end
              end   /*k*/

              do j=i+1  while j<n;       parse value  @.j  @.n   with   @.n  @.j;   n=n-1
              end   /*j*/
            if i==0  then return 0
              do m=i+1  while @.m<@.i;   end  /*m*/          /* [↓]  swap two values.   */
            parse  value   @.m @.i   with   @.i @.m;                          return 1
