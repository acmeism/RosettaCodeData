/*REXX program shows permutations of  N  number of objects (1,2,3, ...).*/
parse arg N seed .;  if N=='' then N=3 /*Not specified?   Assume default*/
permutes=permsets(N)                   /*returns N!  (# of permutations)*/
w=length(permutes)                     /*used for aligning the SAY stuff*/

  do what=0  to permutes-1             /*traipse through each permute.  */
  z=permsets(N, what)                  /*get the  "what"  permuation.   */
  say N 'items, permute' right(what,w)   "="   z  '  rank=' permsets(N,,z)
  end   /*what*/

say;    if seed\==''  then call random ,,seed    /*seed ≡ repeatability.*/
N=12
      do 4;  ?=random(0, N**4)         /*REXX has a  100k  RANDOM range.*/
      say  N   'items, permute'    right(?,6)     " is "     permsets(N,?)
      end   /*rand*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────PERMSETS subroutine─────────────────*/
permsets: procedure expose @. #; #=0;  parse arg x,r,c; c=space(c); xm=x-1

  do j=1 for x; @.j=j-1; end /*j*/; _=0; do u=2 for xm; _=_ @.u; end /*u*/
  if r==#  then return _;  if c==_ then return #

  do while .permsets(x,0); #=#+1; _=@.1; do u=2 for xm; _=_ @.u; end /*u*/
  if r==#  then return _;  if c==_ then return #
  end   /*while···*/
return #+1

.permsets:  procedure expose @.;       parse arg p,q;    pm=p-1
  do k=pm by -1 for pm; kp=k+1; if @.k<@.kp then do; q=k; leave; end;  end
  do j=q+1  while j<p;  parse value @.j @.p with @.p @.j; p=p-1; end
if q==0 then return 0
  do j=q+1  while @.j<@.q;   end;   parse value @.j @.q  with  @.q @.j
return 1
