/*REXX program  lists  (the longest)  ordered word(s)  from a  supplied  dictionary.    */
iFID= 'UNIXDICT.TXT'                             /*the filename of the word dictionary. */
m= 1                                             /*maximum length of an ordered word(s).*/
call linein iFID, 1, 0                           /*point to the first word in dictionary*/
@.=                                              /*placeholder array for list of words. */
   do j=1  while lines(iFID)\==0; x=linein(iFID) /*keep reading until file is exhausted.*/
   w= length(x);       if w<m  then iterate      /*Word not long enough? Then ignore it.*/
   if \datatype(x, 'M')        then iterate      /*Is it not a letter?  Then ignore it. */
   parse upper var  x      xU  1  z  2           /*get uppercase version of X & 1st char*/
        do k=2  for w-1;    _= substr(xU, k, 1)  /*process each letter in uppercase word*/
        if _<z  then iterate j                   /*is letter < than the previous letter?*/
        z= _                                     /*we have a newer current letter.      */
        end   /*k*/                              /* [↑]  logic includes  ≥  order.      */
   m= w                                          /*maybe define a new maximum length.   */
   @.w= @.w  x                                   /*add the original word to a word list.*/
   end   /*j*/                                   /*the 1st DO needs an index for ITERATE*/
              #= words(@.m)                      /*just a handy─dandy variable to have. */
say #  'word's(#)  "found (of length" m')';  say /*show the number of words and length. */
        do n=1  for #;   say word(@.m, n);   end /*display all the words, one to a line.*/
exit                                             /*stick a fork in it,  we're all done. */
ghijk
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:  if arg(1)==1  then return '';   return "s"   /*a simple pluralizer (merely adds "S")*/
