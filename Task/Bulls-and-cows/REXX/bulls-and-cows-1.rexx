/*REXX pgm scores Bulls & Cows game with CBLFs (Carbon Based Life Forms)*/
?=;     do  until  length(?)==4        /*generate unique 4-digit number.*/
        r=random(1,9)                  /*change  1──►0  to allow a 0 dig*/
        if pos(r,?)\==0  then iterate  /*don't allow a repeated digit.  */
        ?=? || r                       /*add random dig by concatenation*/
        end   /*until length··· */     /* [↑]  builds a unique 4-digit #*/

  do  until  bulls==4;      say        /*play until guessed |enters QUIT*/
  say '───── [Bulls & Cows]  Please enter a 4-digit guess (with no zeroes)   [or Quit]:'
  pull n;   n=space(n,0);   if abbrev('QUIT',n,1)  then exit    /*Quit ?*/
  q=?;  L=length(n);  bulls=0;  cows=0 /*initialize some REXX variables.*/

       do j=1  for L;      if substr(n,j,1)\==substr(q,j,1)  then iterate
       bulls=bulls+1                   /*bump the    bull    count.     */
       q=overlay(.,q,j)                /*disallow this for a cow count. */
       end   /*j*/                     /* [↑]  bull count───────────────*/

       do k=1  for L;      _=substr(n,k,1);   if pos(_,q)==0  then iterate
       cows=cows+1                     /*bump the    cow    count.      */
       q=translate(q,,_)               /*this allows for multiple digits*/
       end   /*k*/                     /* [↑]  cow  count───────────────*/
  say
  if L\==0 & bulls\==4  then say "───── You got" bulls 'bull's(bulls) "and" cows 'cow's(cows)"."
  end   /*until bulls···*/

say;   say "          ┌─────────────────────────────────────────┐"
       say "          │                                         │"
       say "          │  Congratulations, you've guessed it !!  │"
       say "          │                                         │"
       say "          └─────────────────────────────────────────┘";    say
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────S subroutine────────────────────────*/
s:  if arg(1)==1  then return '';     return 's'      /*handles plurals.*/
