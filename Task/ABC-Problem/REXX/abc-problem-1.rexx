/*REXX pgm checks if a word list can be spelt from a pool of toy blocks.*/
list = 'A bark bOOk treat common squaD conFuse' /*words can be any case.*/
blocks =     'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM'
       do k=1  for  words(list)        /*traipse through list of words. */
       call  spell  word(list,k)       /*show if word be spelt (or not).*/
       end   /*k*/                     /* [↑] tests each word in list.  */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SPELL subroutine────────────────────*/
spell: procedure expose blocks; parse arg ox . 1 x . /*get word to spell*/
z=blocks; upper x z;  oz=z;  p.=0;  L=length(x) /*uppercase the blocks. */
                                                /* [↓]  try to spell it.*/
  do try=1  for  L;   z=oz                      /*use a fresh copy of Z.*/
    do n=1  for  L;   y=substr(x,n,1)           /*attempt another letter*/
    p.n=pos(y,z,1+p.n); if p.n==0 then iterate try /*¬ found? Try again.*/
    z=overlay(' ',z,p.n)                        /*mutate block──► onesy.*/
      do k=1  for words(blocks)                 /*scrub block pool (¬1s)*/
      if length(word(z,k))==1  then z=delword(z,k,1)  /*1 char?  Delete.*/
      end   /*k*/                               /* [↑]  elide any onesy.*/
    if n==L   then leave try                    /*the last letter spelt?*/
    end     /*n*/                               /* [↑] end of an attempt*/
  end       /*try*/                             /* [↑]  end TRY permute.*/

say right(ox,30)   right(word("can't can", (n==L)+1),  6)      'be spelt.'
return n==L                                     /*also, return the flag.*/
