/*REXX pgm generates all permutations of N derangements & subfactorial #*/
numeric digits 1000                    /*be able to handle big subfacts.*/
parse arg N .;   if N=='' then N=4     /*Not specified?   Assume default*/
d=derangementsSet(N)                   /*go & build the derangements set*/
say d  'derangements for'   N   "items are:"
say
      do i=1  for  d                   /*show derangements for  N items.*/
      say right('derangement',22)   right(i,length(d))    '───►'    $.i
      end   /*i*/
say                                    /* [↓]  count and calculate  !L. */
      do L=0  to 9;  d=derangementsSet(L)
      say L 'items:  derangement count='right(d,6)",  !"L'='right(!s(L),6)
      end   /*L*/
say
say right('!20=' , 40)   !s( 20)
say right('!100=', 40)   !s(100)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────!S subroutine───────────────────────*/
!s: _=1; do j=1 for arg(1);if j//2 then _=-1+j*_;else _=1+j*_;end;return _
/*──────────────────────────────────DERANGEMENTSSET subroutine──────────*/
derangementsSet: procedure expose $.;  parse arg x;   $.=;    #=0;   p=x-1
if x==0  then return 1;  if x==1  then return 0
                                       /*populate the first derangement.*/
@.1=2;  @.2=1;                         do i=3  to x;  @.i=i;  end
parse value  @.p @.x  with  @.x @.p;   call .buildD x    /*swap & build.*/
                                                         /*build others.*/
           do while .nextD(x,0);       call .buildD x;   end
return #
/*──────────────────────────────────.BUILDD subroutine──────────────────*/
.buildD:      do j=1  for arg(1);   if @.j==j  then return; end
#=#+1;        do j=1  for arg(1);   $.#=$.# @.j;            end;    return
/*──────────────────────────────────.NEXTD subroutine───────────────────*/
.nextD:  procedure expose @.;    parse arg n,i;    nm=n-1

  do k=nm  by -1  for nm;  kp=k+1;   if @.k<@.kp  then do; i=k; leave; end
  end   /*k*/

      do j=i+1  while j<n;  parse value @.j @.n with @.n @.j;  n=n-1;  end

if i==0  then return 0
                                         do j=i+1  while @.j<@.i;   end
parse  value   @.j @.i   with   @.i @.j
return 1
