/*REXX program scores the   Bulls & Cows   game with  CBLFs  (Carbon Based Life Forms). */
?=; do  until length(?)==4;   r= random(1, 9)  /*generate a unique four-digit number.   */
    if pos(r,?)\==0  then iterate;  ?= ? || r  /*don't allow a repeated digit/numeral.  */
    end   /*until length*/                     /* [↑]  builds a unique four-digit number*/
$= '──────── [Bulls & Cows]  '                 /*a literal that is part of the prompt.  */
    do  until  bulls==4;      say              /*play until guessed  or  enters  "Quit".*/
    say $  'Please enter a 4-digit guess (with no zeroes)   [or Quit]:'
    pull n;  n=space(n, 0);   if abbrev('QUIT', n, 1)  then exit   /*user wants to quit?*/
    q=?;   L= length(n);   bulls= 0;   cows= 0 /*initialize some REXX variables.        */
        do j=1  for L;    if substr(n, j, 1)\==substr(q, j, 1)  then iterate  /*is bull?*/
        bulls= bulls +1;  q= overlay(., q, j)  /*bump the bull count;  disallow for cow.*/
        end   /*j*/                            /* [↑]  bull count───────────────────────*/
                                                                              /*is cow? */
        do k=1  for L;   _= substr(n, k, 1);           if pos(_, q)==0  then iterate
        cows=cows + 1;   q= translate(q, , _)  /*bump the cow count;  allow mult digits.*/
        end   /*k*/                            /* [↑]  cow  count───────────────────────*/
    say;                  @= 'You got'   bulls
    if L\==0  &  bulls\==4  then say $  @  'bull's(bulls)    "and"    cows   'cow's(cows).
    end   /*until bulls*/
                            say "          ┌─────────────────────────────────────────┐"
                            say "          │                                         │"
                            say "          │  Congratulations, you've guessed it !!  │"
                            say "          │                                         │"
                            say "          └─────────────────────────────────────────┘"
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:  if arg(1)==1  then return '';   return "s"   /*this function handles pluralization. */
