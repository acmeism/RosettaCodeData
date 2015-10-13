/*REXX program determines if words can be spelt from a pool of toy blocks.    */
list=  'A bark bOOk treat common squaD conFuse'   /*words can be in any case. */
blocks= 'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM'
          do k=1  for  words(list)     /*traipse through a list of seven words*/
          call  spell  word(list,k)    /*display if word can be spelt (or not)*/
          end   /*k*/                  /* [↑]  tests each word in the list.   */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
spell: procedure expose blocks;  arg x;  p.=0   /*uppercase word to be spelt. */
parse upper var blocks theBlocks;  L=length(x)  /*uppercase the block letters.*/
                                                /* [↓]  try to spell the word.*/
  do try=1  for  L;   z=theBlocks               /*use a fresh copy of Z blocks*/
    do n=1  for  L;   y=substr(x,n,1)           /*attempt another block letter*/
    p.n=pos(y,z,1+p.n);  if p.n==0  then iterate try   /*not found? Try again.*/
    z=overlay(' ',z,p.n)                        /*mutate block  ───►  a onesy.*/
      do k=1  for words(blocks)                 /*scrub block pool  (not 1s). */
      if length(word(z,k))==1  then z=delword(z,k,1)   /*single char?  Delete.*/
      end   /*k*/                               /* [↑]  elide any onesy block.*/
    if n==L  then leave try                     /*was the last letter spelt?  */
    end     /*n*/                               /* [↑]  end of a block attempt*/
  end       /*try*/                             /* [↑]  end of "TRY" permute. */

say right(arg(1),30)    right(word("can't can", (n==L)+1), 6)        'be spelt.'
return
