/*REXX program displays permutations of   N   number of  objects  (1, 2, 3,  ···).      */
parse arg N y seed .                             /*obtain optional arguments from the CL*/
if N=='' | N==","  then N= 4                     /*Not specified?  Then use the default.*/
if y=='' | y==","  then y=17                     /* "      "         "   "   "     "    */
if datatype(seed,'W')  then call random ,,seed   /*can make RANDOM numbers repeatable.  */
permutes= permSets(N)                            /*returns  N! (number of permutations).*/
w= length(permutes)                              /*used for aligning the  SAY  output.  */
@.=
      do p=0  to permutes-1                      /*traipse through each of the permutes.*/
      z=permSets(N, p)                           /*get which of the  permutation  it is.*/
      say 'for'     N     "items, permute rank"      right(p,w)        'is: '        z
      @.p=z                                      /*define a rank permutation in @ array.*/
      end   /*p*/
say                                              /* [↓]  displays a particular perm rank*/
say '  the permutation rank of'  y  "is: "   @.y /*display a particular permuation rank.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
permSets:   procedure expose @. #;     #=0;    parse arg x,r,c;   c=space(c);      xm=x -1
                    do j=1  for x;     @.j=j-1;   end  /*j*/
            _=0;    do u=2  for xm;    _=_ @.u;   end  /*u*/
            if r==#  then return _;            if c==_  then return #
                    do  while .permSets(x,0);  #=#+1;  _=@.1
                       do v=2  for xm;    _=_  @.v;    end  /*v*/
                    if r==#  then return  _;   if c==_  then return #
                    end   /*while···*/
            return #+1
/*──────────────────────────────────────────────────────────────────────────────────────*/
.permSets:  procedure expose @.;       parse arg p,q;    pm=p-1
                  do k=pm  by -1  for pm;   kp=k+1;  if @.k<@.kp  then do; q=k; leave; end
                  end   /*k*/

                  do j=q+1  while j<p;  parse  value  @.j  @.p   with   @.p  @.j;   p=p -1
                  end   /*j*/
            if q==0  then return 0
                  do p=q+1  while @.p<@.q;   end  /*p*/
            parse  value   @.p  @.q   with   @.q  @.p
            return 1
