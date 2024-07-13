/*REXX pgm finds circular words (length>2), using a dictionary, suppress permutations.*/
parse arg iFID L .                           /*obtain optional arguments from the CL  */
if iFID==''|iFID==","  then iFID='unixdict.txt' /*Not specified?  Then use the default*/
if    L==''|   L==","  then    L=3              /* "      "         "   "   "     "   */
word.=0
have.=0
do r=0 while lines(iFID)>0                   /*read all lines (words) in dictionary.*/
  parse upper value linein(iFID) with w .    /*obtain a word from the dictionary.   */
  if length(w)>=3 &,                         /*length must be  L  or more           */
     datatype(w,'U') &,                      /*Word must be all letters             */
     have.w=0 then do                        /*No duplicates                        */
    z=word.0+1                               /* number of eligible words            */
    word.0=z
    word.z=w                                 /*Word number z                        */
    have.w=1                                 /*is available                         */
    end   /*r*/                              /*dictionary need not be sorted.       */
  End
cw=0                                         /*the number of circular words (so far)*/
say 'There''re ' r ' entries (of all types) in the dictionary' iFID
say 'There''re ' word.0 ' words in the dictionary of at least length 'L
say
do j=1 To word.0                             /* loop through words                  */
  if word.j>''  then do                      /* word is available                   */
    w=word.j                                 /* base for circulation                */
    lw=length(w)                             /* number of letters                   */
    cl=w
    ci=1
    do k=1 for lw-1                          /*'circulate' the letters in the word. */
      w=substr(w,2)left(w,1)                 /*move the first letter to the end.    */
      If have.w Then Do                      /*available word                       */
        cl=cl','w                            /*add it to list                       */
        ci=ci+1                              /*list items                           */
        have.w=0                             /*no longer available                  */
        End
      Else
        Leave
      end   /*k*/
    If ci=lw Then Do                         /*complete list                        */
      say 'circular word: ' cl               /*display a circular word and variants.*/
      cw=cw + 1                              /*bump counter of circular words found.*/
      End
    End
  end   /*j*/
say
say cw ' circular words were found.'         /*stick a fork in it,  we're all done. */
