/*REXX program lists (longest) ordered words from a supplied dictionary.*/
ifid = 'UNIXDICT.TXT'                  /*filename of the word dictionary*/
@.=                                    /*placeholder for list of words. */
mL=0                                   /*maximum length of ordered words*/
call linein ifid, 1, 0                 /*point to the first word in dict*/
                                       /* [↑]  in case the file is open.*/
  do j=1  while  lines(ifid)\==0       /*keep reading until exhausted.  */
  x=linein(ifid);     w=length(x)      /*get a word and also its length.*/
  if w<mL  then iterate                /*if not long enough, ignore it. */
  xU=x;    upper xU                    /*create uppercase version of  X.*/
  z=left(xU,1)                         /*now, see if the word is ordered*/
                                           /*handle words of mixed case.*/
        do k=2  to w;    _=substr(xU,k,1)  /*process each letter in word*/
        if \datatype(_,'U') then iterate   /*Not a letter? Then skip it.*/
        if _<z              then iterate j /*is letter < than previous ?*/
        z=_                                /*have newer current letter. */
        end   /*k*/                        /* [↑]  logic includes≥order.*/
  mL=w                                 /*maybe define a new maximum len.*/
  @.w=@.w  x                           /*add orig. word to  a word list.*/
  end     /*j*/

#=words(@.mL)                          /*just a handy-dandy var to have.*/
say # 'word's(#) "found (of length" mL')';  say   /*show #words & length*/
   do n=1  for #;        say word(@.mL,n);  end   /*list all the words. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1  then return '';     return 's'   /*a simple pluralizer.*/
