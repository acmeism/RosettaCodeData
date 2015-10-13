/*REXX program counts the occurrences of all characters in a file, & note that*/
/*     all Latin alphabet letters are uppercased for counting {Latin} letters.*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
abc = 'abcdefghijklmnopqrstuvwxyz'     /*define an (Latin or English) alphabet*/
abcU= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'     /*define an uppercase version of  [↑]. */
parse arg fileID .                     /*this last char isn't a middle dot: · */
if fileID==''  then fileID='JUNK.TXT'  /*¿none specified? Then use the default*/
totChars=0;    totLetters=0            /*count of all chars and of all letters*/
pad=left('',18);    pad9=left('',18%2) /*used for the indentations of output. */
@.=0                                   /*wouldn't it be neat to use Θ instead?*/
     do j=1  while lines(fileID)\==0   /*read the file 'til the cows come home*/
     rec=linein(fileID)                /*get a line/record from the input file*/
                                       /* [↓]  process all characters in  REC.*/
       do k=1  for length(rec)         /*examine/count each of the characters.*/
       totChars=totChars+1             /*bump count of number of characters.  */
       c=substr(rec,k,1);  @.c=@.c+1   /*Peel off a character; bump its count.*/
       if \datatype(c,'M') then iterate  /*Not a Latin letter?  Get next char.*/
       totLetters=totLetters+1         /*bump the count for [Latin] letters.  */
       upper c   /* ◄«««««««««««««««««««««««««««◄ uppercase a Latin character.*/
       @..c=@..c+1                     /*bump the (Latin) letter's count.     */
       end   /*k*/                     /*no Greek glyphs: π Γ Σ µ α ß Φ ε δ σ */
     end     /*j*/                     /*maybe we're ½ done by now, or maybe ¬*/
                                           LL= '(Latin) letter'
w=length(totChars)                     /*used for right─aligning the counts.  */
say 'file ─────' fileId "───── has" j-1 'records and has' totLetters LL"s."; say
  do L=0  for 256;    c=d2c(L)         /*display all none─zero letter counts. */
  if @..c==0  then iterate             /*A zero count?  Then ignore character.*/
  say pad9  LL' '   c   " (also" translate(c,abc,abcU)')  count:'  right(@..c,w)
  end   /*L*/                          /*we may be in a rut, but not a cañyon.*/

say;    say 'file ─────'  fileId   "───── has"   totChars   'unique characters.'
say
     do #=0  for 256;    y=d2c(#)      /*display all none─zero char counts.   */
     if @.y==0  then iterate           /*A zero count?  Then ignore character.*/
     c=d2c(#);  ch=c                   /*C  is the character glyph of a char. */
     if c<<' ' | #==255  then ch=      /*don't show control characters or null*/
     if c==' '           then ch='blank'                /*show a blank's name.*/
     say pad right(ch,5)     " ('"d2x(#,2)"'x  character count:"    right(@.c,w)
     end   /*#*/                       /*255 isn't quite ∞, but sometimes ∙∙∙ */
say                                    /*not a good place for dithering: ░▒▓█ */
say  pad   pad9   '☼ end─of─list ☼'    /*show we are at the end of the list.  */
                                       /*stick a fork in it, we're all done. ☻*/
