/*REXX program finds palindrome pairs using a dictionary  (UNIXDICT.TXT)*/
#=0                                    /*number of palindromes (so far).*/
parse arg iFID .;   if iFID=='' then iFID='UNIXDICT.TXT'  /*use default?*/
@.=                                    /*caseless non-duplicated words. */
     do while lines(ifid)\==0;  _=linein(iFID);   u=translate(space(_,0))
     if length(u)<2 | @.u\==''  then iterate    /*can't be a unique pal.*/
     r=reverse(u)
     if @.r\==''  then do;      #=#+1           /*found palindrome pair.*/
                       if #<6 then say @.r',' _ /*only list first 5 pals*/
                       end
     @.u=_
     end   /*while*/
say                           /*a unique palindrome pair = a semordnilap*/
say "There're"  #  'unique palindrome pairs in the dictionary file:'  iFID
                                       /*stick a fork in it, we're done.*/
