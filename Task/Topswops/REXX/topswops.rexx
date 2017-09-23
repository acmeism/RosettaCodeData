/*REXX program generates  N  decks of  numbered cards  and  finds the maximum  "swops". */
parse arg things .;          if things=='' then things=10

      do n=1  for things;          #=decks(n, n) /*create a (things) number of "decks". */
      mx= n\==1                                  /*handle the case of a  one-card  deck.*/
                  do i=1  for #;   p=swops(!.i)  /*compute the SWOPS for this iteration.*/
                  if p>mx  then mx=p             /*This a new maximum?   Use a new max. */
                  end   /*i*/
      say '──────── maximum swops for a deck of'   right(n,2)   ' cards is'    right(mx,4)
      end   /*n*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
decks:  procedure expose !.; parse arg x,y,,$ @. /*   X  things  taken   Y   at a time. */
        #=0;                 call .decks 1       /* [↑]  initialize  $  &   @.  to null.*/
        return #                                 /*return number of permutations (decks)*/
.decks: procedure expose !. @. x y $ #;          parse arg ?
        if ?>y  then do;  _=@.1;  do j=2  for y-1;  _=_ @.j;  end  /*j*/;    #=#+1;  !.#=_
                     end
                else do;              qm=?-1
                     if ?==1  then qs=2          /*don't use 1-swops that start with  1 */
                              else if @.1==?  then qs=2  /*skip the 1-swops: 3 x 1 x ···*/
                                              else qs=1
                       do q=qs  to x             /*build the permutations recursively.  */
                             do k=1  for qm;  if @.k==q  then iterate q
                             end  /*k*/
                       @.?=q;                 call .decks ? + 1
                       end    /*q*/
                     end
        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
swops:  parse arg z;    do u=1;    parse var z t .;     if length(t)==2  then t=x2d(t)
                        if word(z, t)==1  then return u             /*found unity at T. */
                                do h=10  to things;     if pos(h, z)==0  then iterate
                                z=changestr(h, z, d2x(h) )    /* [↑]  any  H's  in  Z ? */
                                                              /* [↑]  hexify decimal  H */
                                end   /*h*/
                        z=reverse(subword(z, 1, t))  subword(z, t+1)
                        end   /*u*/
