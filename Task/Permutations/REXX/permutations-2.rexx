/*REXX program displays  permutations  of   N   number of  objects  (1, 2, 3, ···).     */
parse arg n .;    if n=='' | n==","  then n=3    /*Not specified?  Then use the default.*/
                                                 /* [↓]  populate the first permutation.*/
         do pop=1  for n;            @.pop=pop  ;     end  /*pop  */;          call tell n
         do  while nPerm(n, 0);      call tell n;     end  /*while*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
nPerm: procedure expose @.;     parse arg n,i;    nm=n-1
         do k=nm  by -1  for nm;  kp=k+1; if @.k<@.kp  then do; i=k; leave; end; end /*k*/
         do j=i+1  while j<n;  parse value  @.j  @.n   with   @.n  @.j;   n=n-1; end /*j*/
         if i==0  then return 0
                                                     do m=i+1  while  @.m<@.i;  end  /*m*/
         parse value  @.m  @.i  with  @.i  @.m
         return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell:    procedure expose @.;  _=;    do j=1  for arg(1);  _=_ @.j;  end;   say _;  return
