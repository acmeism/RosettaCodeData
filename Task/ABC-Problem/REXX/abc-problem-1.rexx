/*REXX pgm finds if words can be spelt from a pool of toy blocks (each having 2 letters)*/
list= 'A bark bOOk treat common squaD conFuse'   /*words can be:  upper/lower/mixed case*/
blocks= 'BO  XK  DQ  CP  NA  GT  RE  TG  QD  FS  JW  HU  VI  AN  OB  ER  FS  LY  PC  ZM'
              do k=1  for  words(list)           /*traipse through a list of some words.*/
              call  spell  word(list, k)         /*display if word can be spelt (or not)*/
              end   /*k*/                        /* [↑]  tests each word in the list.   */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
spell: procedure expose blocks;  arg x           /*ARG  uppercases the word to be spelt.*/
                         L=length(x);    @.=0    /*get length of the word to be spelt.  */
           do try=1  for L;  z=blocks;   upper z /*use a fresh copy of the  "Z"  blocks.*/
             do n=1  for L;  y=substr(x, n, 1)   /*attempt another letter in the word.  */
             @.n=pos(y, z, 1 + @.n);     if @.n==0  then leave   /*not found?  Try again*/
             z=overlay(' ', z, @.n)              /*mutate the toy block  ───►  a onesy. */
                do q=1  for words(z);    if length(word(z, q))==1  then z=delword(z, q, 1)
                end   /*q*/                      /* [↑]  elide any existing onesy block.*/
             if n==L  then leave try             /*was last letter used in the spelling?*/
             end      /*n*/                      /* [↑]  end of a  toy block  usage.    */
           end        /*try*/                    /* [↑]  end of a  "TRY"  permute.      */
       say right(arg(1), 30)     right( word( "can't can", (n==L) +1), 6)      'be spelt.'
       return
