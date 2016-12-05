/*REXX program finds  palindrome pairs in a dictionary  (the default is  UNIXDICT.TXT). */
#=0                                                       /*number palindromes (so far).*/
parse arg iFID .;  if iFID==''  then iFID='UNIXDICT.TXT'  /*Not specified?  Use default.*/
@.=                                                       /*uppercase no─duplicated word*/
    do  while lines(iFID)\==0;  _=space(linein(iFID),0)   /*read a word from dictionary.*/
    parse upper var _ u                                   /*obtain an uppercase version.*/
    if length(_)<2 | @.u\==''  then iterate               /*can't be a unique palindrome*/
    r=reverse(u)                                          /*get the reverse of the word.*/
    if @.r\==''  then do;  #=#+1                          /*find a palindrome pair ?    */
                           if #<6  then say  @.r','   _   /*just show 1st 5 palindromes.*/
                      end                                 /* [↑]  bump palindrome count.*/
    @.u=_                                                 /*define a unique palindrome. */
    end   /*while*/                                       /* [↑]  read the dictionary.  */
say
say "There're "      #      ' unique palindrome pairs in the dictionary file: '       iFID
                                                      /*stick a fork in it, we're done. */
