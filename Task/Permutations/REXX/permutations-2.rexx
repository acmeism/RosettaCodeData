/*REXX program shows permutations of  N  number of objects (1,2,3, ...).*/
parse arg n .;   if n=='' then n=3     /*Not specified?  Assume default.*/
                                       /*populate the first permutation.*/
        do pop=1  for n;          @.pop=pop  ;   end;          call tell n

        do while nextperm(n,0);   call tell n;   end
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────NEXTPERM subroutine─────────────────*/
nextperm:  procedure expose @.;    parse arg n,i;    nm=n-1

  do k=nm  by -1  for nm;  kp=k+1
  if @.k<@.kp  then                 do;  i=k;  leave;  end
  end   /*k*/

      do j=i+1  while j<n;  parse value @.j @.n with @.n @.j;  n=n-1;  end

if i==0  then return 0
                                         do j=i+1  while  @.j<@.i;   end
parse  value   @.j @.i   with   @.i @.j
return 1
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell: procedure expose @.; _=; do j=1 for arg(1);_=_ @.j;end; say _;return
