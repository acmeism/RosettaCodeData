/*REXX program counts the occurrences of all characters in a file,      */
/* {all Latin alphabet letters are uppercased for counting letters}.    */

parse arg fileID .                     /*That's not a middle dot:  ·    */
if fileID=='' then fileID='JUNK.TXT'   /*¿none specified?   Use default.*/
@.=0                                   /*wouldn't it be neat to use Θ ? */
totChars=0                             /*count of the total num of chars*/
totLetters=0                           /*count of the total num letters.*/
indent=left('',20)                     /*used for indentation of output.*/

  do j=1 while lines(fileID)\==0       /*read file until cows come home.*/
  rec=linein(fileID)                   /*get a line/record from the file*/

       do k=1 for length(rec)          /*examine/count each character.  */
       totChars=totChars+1             /*bump the count of num of chars.*/
       c=substr(rec,k,1)               /*peel off a character from input*/
       x=c2x(c)                        /*convert the character to hex.  */
       @.x=@.x+1                       /*bump the character's count.    */
       if \datatype(c,'M') then iterate /*if not a letter, get next char*/
       totLetters=totLetters+1         /*bump the [Latin] letter count. */
       upper c    /* ◄«««««««««««««««««««───uppercase a Latin character.*/
       x=c2x(c)                        /*convert uppCase letter ══► hex.*/
       @.up.x=@.up.x+1                 /*bump the (Latin) letter's count*/
       end    /*k*/                    /*this program doesn't use π or Γ*/

  end         /*j*/                    /*maybe we're ½ done by now, or ¬*/

w=length(totChars)                     /*used for right-aligning counts.*/
say 'file ─────' fileId "───── has" j-1 'records.'          ;     say
say 'file ─────' fileId "───── has" totChars 'characters.'  ;     say

  do L=0 to 255                        /*display none-zero letter counts*/
  y=d2x(L); if @.up.y==0 then iterate  /*zero count?  Then ignore letter*/
  c=d2c(L)                             /*C is the char version of a char*/
  say indent "(Latin) letter " c 'count:' right(@.up.y,w)
  end     /*L*/                        /*in a rut,  maybe it's a cañon. */

say; say 'file ─────' fileId "───── has" totLetters '(Latin) letters.'; say

  do m=0 to 255                        /*display none-zero char counts. */
  y=d2x(m); if @.y==0 then iterate     /*Zero count?   Then ignore char.*/
  c=d2c(m)                             /*C is the char version of a char*/
  _=right(@.y,w)                       /*bad place for dithering:  ░▒▓█ */

       select                          /*make the character viewable.   */
       when c<<' ' | m==255 then say indent  "'"y"'x character count:" _
       when c==' '          then say indent   "blank character count:" _
       otherwise                 say indent "   " c 'character count:' _
       end    /*select*/               /*I wish REXX had a  Σ  function.*/
  end         /*m*/                    /*255 isn't ∞, but sometimes ∙∙∙ */

say;   say 'file ─────' fileId "───── has" totChars 'characters.'    /*Ω*/
