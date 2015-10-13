/*REXX program lists (the longest) ordered word(s) from a supplied dictionary.*/
iFID = 'UNIXDICT.TXT'                  /*the filename of the word dictionary. */
@.=                                    /*placeholder array for list of words. */
mL=0                                   /*maximum length of the ordered words. */
call linein iFID, 1, 0                 /*point to the first word in dictionary*/
                                       /* [↑]  just in case the file is open. */
  do j=1  while  lines(iFID)\==0       /*keep reading until file is exhausted.*/
  x=linein(iFID);       w=length(x)    /*obtain a word and also its length.   */
  if w<mL  then iterate                /*Word not long enough? Then ignore it.*/
  xU=x;    upper xU                    /*create uppercase version of word  X. */
  z=left(xU,1)                         /*now, determine if the word is ordered*/
                                              /*handle words of mixed case.   */
        do k=2  to w;    _=substr(xU,k,1)     /*process each letter in word.  */
        if \datatype(_,'U')  then iterate     /*Not a letter?  Then ignore it.*/
        if _<z               then iterate j   /*is letter < than previous ?   */
        z=_                                   /*we have newer current letter. */
        end   /*k*/                           /* [↑]  logic includes ≥ order. */
  mL=w                                 /*maybe define a new maximum length.   */
  @.w=@.w  x                           /*add the original word to a word list.*/
  end         /*j*/

#=words(@.mL)                          /*just a handy─dandy variable to have. */
say #  'word's(#)  "found (of length" mL')';     say  /*show # words & length.*/
          do n=1  for #;      say word(@.mL,n);  end  /*list all the words.   */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
s:  if arg(1)==1  then return '';        return 's'     /*a simple pluralizer.*/
