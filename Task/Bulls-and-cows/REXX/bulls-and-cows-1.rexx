/*REXX pgm interactively plays a game of  "Bulls & Cows"  with  CBLs.   */
/*                                     [CBLs = Carbon Based Lifeforms.] */
/*                                                                      */
/*     This game is also known as:         Cows and Bulls               */
/*                                         Pigs and Bulls               */
/*                                         Bulls and Cleots             */
/*                                         MasterMind (or Master Mind)  */
/*══════════════════════════════════════════════════════════════════════*/
?='';  do until length(?)==4           /*generate unique 4-digit number.*/
       r=random(1,9)                   /*change  1──►0  to allow a 0 dig*/
       if pos(r,?)\==0 then iterate    /*don't allow a repeated digit.  */
       ?=? || r
       end   /*until*/

prompt='[Bulls & Cows game] ',         /*build the prompt text string.  */
              "Please enter a 4-digit guess (with no zeroes)   [or Quit]:"

  do until bulls==4                    /*play until guessed |enters QUIT*/
  say prompt;  pull n;  n=space(n,0);  if n=='' then iterate
  if abbrev('QUIT',n,1) then exit      /*Does the user want to quit now?*/
  g=?;  L=length(n);  bulls=0;  cows=0
                                       /*bull count─────────────────────*/
       do j=1 for L;  if substr(n,j,1)\==substr(g,j,1)  then iterate
       bulls=bulls+1                   /*bump the bull count.           */
       g=overlay(' ',g,j)              /*disallow this for a cow count. */
       end   /*j*/
                                       /*cow  count─────────────────────*/
          do k=1 for L;  x=substr(n,k,1);   if pos(x,g)==0 then iterate
          cows=cows+1                  /*bump the cow count.            */
          g=translate(g,,x)            /*this allows for rule variants. */
          end   /*k*/

  if bulls\==4 then say "───── You got" bulls 'bull's(bulls) "and" cows 'cow's(cows)"."
  end       /*until bulls==4*/

say;   say "          ┌─────────────────────────────────────────┐"
       say "          │                                         │"
       say "          │  Congratulations, you've guessed it !!  │"
       say "          │                                         │"
       say "          └─────────────────────────────────────────┘";    say
exit
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1  then return '';  return 's'
