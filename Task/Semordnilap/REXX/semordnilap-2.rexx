/*REXX program finds palindrome pairs using a dictionary (UNIXDICT.TXT).*/
#=0                                             /*# palindromes (so far)*/
parse arg iFID .;  if iFID==''  then iFID='UNIXDICT.TXT'  /*use default?*/
@.=                                             /*caseless no-duped word*/
    do while lines(iFID)\==0; _=space(linein(iFID),0); parse upper var _ u
    if length(_)<2 | @.u\==''  then iterate     /*can't be a unique pal.*/
    r=reverse(u)                                /*get the reverse of U. */
    if @.r\==''  then do;     #=#+1             /*found palindrome pair?*/
                      if #<6  then say @.r',' _ /*only list first 5 pals*/
                      end                       /* [↑]  bump count, show*/
    @.u=_                                       /*define palindromic pal*/
    end   /*while*/                             /* [↑]  read dictionary.*/
say
say "There're"  #  'unique palindrome pairs in the dictionary file: ' iFID
                                       /*stick a fork in it, we're done.*/
