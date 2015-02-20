/*REXX program  finds  "sets" (solutions)  for the  SET  puzzle (game). */
parse arg game seed .                  /*get optional # cards to deal.  */
if game ==',' | game==''  then game=9  /*Not specified? Then use default*/
if seed==','  | seed==''  then seed=77 /* "      "        "   "     "   */
call aGame 0                           /*with tell=0,  suppress output. */
call aGame 1                           /*with tell=1,   allow   output. */
exit sets                              /*stick a fork in it, we're done.*/
/*──────────────────────────────────AGAME subroutine────────────────────*/
aGame: tell=arg(1);        good=game%2 /*enable or disable the output.  */
                                       /* [↑]  GOOD is the right # sets.*/
       do seed=seed  until good==sets  /*generate deals until good# sets*/
       call random ,,seed              /*repeatability for last invoke. */
       call genFeatures                /*generate various card features.*/
       call genDeck                    /*generate a deck (with 81 cards)*/
       call dealer   game              /*deal a number of cards (game). */
       call findSets game%2            /*find sets from the dealt cards.*/
       end   /*until*/                 /*when leaving, SETS is right num*/
return                                 /*return to invoker of this sub. */
/*──────────────────────────────────DEALER subroutine───────────────────*/
dealer: call sey  'dealing'  game  "cards:",,.  /*shuffle and deal cards*/
    do cards=1  until  cards==game              /*keep dealing 'til done*/
    _=random(1,words(##));  ##=delword(##,_,1)  /*pick card; delete it. */
    @.cards=deck._                              /*add it to the tableau.*/
    call sey right('card' cards,30) " " @.cards /*display card to screen*/
        do j=1  for words(@.cards)              /*define cells for card.*/
        @.cards.j=word(@.cards,j)               /*define a cell for card*/
        end   /*j*/
    end       /*cards*/
return
/*──────────────────────────────────DEFFEATURES subroutine──────────────*/
defFeatures:  parse arg what,v; _=words(v)      /*obtain what to define.*/
if _\==values  then do;  call sey 'error,'  what  "features ¬=" values,.,.
                    exit -1
                    end                         /* [↑]  check for typos.*/
        do k=1  for words(values)               /*define all possibles. */
        call value what'.'k, word(values,k)     /*define a card feature.*/
        end   /*k*/
return
/*──────────────────────────────────GENDECK subroutine──────────────────*/
genDeck: #=0;  ##=                     /*#cards in deck; ##=shuffle aid.*/
      do       num=1  for values;   xnum=word(numbers,  num)
        do     col=1  for values;   xcol=word(colors,   col)
          do   sym=1  for values;   xsym=word(symbols,  sym)
            do sha=1  for values;   xsha=word(shadings, sha)
            #=#+1; ##=## #;  deck.#=xnum xcol xsym xsha /*create a card.*/
            end   /*sha*/
          end     /*num*/
        end       /*sym*/
      end         /*col*/
return                                 /*#: the number of cards in deck.*/
/*──────────────────────────────────GENFEATURES subroutine──────────────*/
genFeatures: features=3; groups=4; values=3   /*define # feats,grps,vals*/
numbers = 'one two three'           ; call defFeatures 'number',  numbers
colors  = 'red green purple'        ; call defFeatures 'color',   colors
symbols = 'oval squiggle diamond'   ; call defFeatures 'symbol',  symbols
shadings= 'solid open striped'      ; call defFeatures 'shading', shadings
return
/*──────────────────────────────────GENPOSS subroutine──────────────────*/
genPoss: p=0; sets=0; sep=' ───── '; !.=   /*define some REXX variables.*/
  do     i=1    for game               /* [↓]  the  IFs  eliminate dups.*/
    do   j=i+1  to game;  if j==i         then iterate
      do k=j+1  to game;  if k==j | k==i  then iterate
      p=p+1;              !.p.1=@.i;      !.p.2=@.j;        !.p.3=@.k
      end   /*k*/
    end     /*j*/
  end       /*i*/                      /* [↑]  build permutation list.  */
return
/*──────────────────────────────────FINDSETS subroutine─────────────────*/
findSets:  parse arg n;   call genPoss /*N:  the number of sets to find.*/
call sey                               /*find any sets generated above. */
    do         j=1  for p              /*P  is the # of possible sets.  */
        do     f=1  for features
            do g=1  for groups;   !!.j.f.g=word(!.j.f, g)
            end   /*g*/
        end       /*f*/
    ok=1                               /*everything is  OK  so far.     */
        do g=1  for groups; _=!!.j.1.g /*generate strings to hole poss. */
        equ=1                          /* [↓]  handles all equal feats. */
               do f=2  to features while equ;       equ=equ & _==!!.j.f.g
               end   /*f*/
        dif=1
        __=!!.j.1.g                    /* [↓]  handles all unequal feats*/
                        do f=2  to  features  while  \equ
                        dif=dif & wordpos(!!.j.f.g,__)==0
                        __=__ !!.j.f.g /*append to string for next test.*/
                        end   /*f*/
        ok=ok&(equ|dif)                /*now, see if all equal | unequal*/
        end   /*g*/

    if \ok  then iterate               /*Is this set OK?  Nope, skip it.*/
    sets=sets+1                        /*bump the number of sets found. */
    call sey  right('set'  sets":  ",15)   !.j.1   sep  !.j.2   sep  !.j.3
    end   /*j*/

call sey  sets  'sets found.',.
return
/*──────────────────────────────────SEY subroutine──────────────────────*/
sey: if \tell  then  return            /*should output be suppressed?   */
if arg(2)==.  then say;   say arg(1);  if arg(3)==.  then say;      return
