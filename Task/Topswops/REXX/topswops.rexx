/*REXX pgm gens N decks of numbered cards and finds the maximum "swops".*/
parse arg things .;  if things=='' then things=10;   thingsX= things>9

      do n=1  for things;    #=deckSets(n,n)           /*create "decks".*/
      mx= n\==1                        /*handle case of a one-card deck.*/
                 do i=1  for #
                 mx=max(mx,swops(!.i))
                 end   /*i*/
      say '──────── maximum swops for a deck of' right(n,2) ' cards is' right(mx,4)
      end   /*n*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DECKSETS subroutine─────────────────*/
deckSets: procedure expose !.          /*X  things  taken  Y  at a time.*/
parse arg x,y,,$ @.;   #=0;   call .deckset 1      /*set $ & @. to null.*/
return #                               /*return  # permutations (decks).*/
.deckset: procedure expose @. x y $ # !.;      parse arg ?
if ?>y then do; _=@.1;   do j=2 to y; _=_ @.j; end  /*j*/;   #=#+1;  !.#=_
            end
       else do
            ?m=?-1                     /*used in the FOR for faster  DO.*/
            if ?==1 then qs=2          /*¬ use 1-swops that start with 1*/
                    else do
                         qs=1
                         if @.1==? then qs=2   /*skip 1-swops:  3 x 1 x */
                         end
              do q=qs  to x            /*build permutation recursively. */
                 do k=1  for ?m;   if @.k==q  then iterate q;   end  /*k*/
              @.?=q;               call .deckset(?+1)
              end    /*q*/
            end
return
/*──────────────────────────────────SWOPS subroutine────────────────────*/
swops: parse arg z;      do _=1;          t=word(z,1)
                         if word(z,t)==1  then return _
                         if thingsX       then do h=10  to things
                                               z=changestr(h,z,d2x(h))
                                               end   /*h*/
                         z=reverse(subword(z,1,t))  subword(z,t+1)
                         if thingsX       then do d=10  to things
                                               z=changestr(d2x(d),z,d)
                         end   /*_*/
