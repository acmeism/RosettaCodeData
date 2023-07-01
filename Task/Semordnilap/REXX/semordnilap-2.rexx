/*REXX program finds  N  semordnilap pairs using a specified dictionary  (UNIXDICT.TXT).*/
parse arg n iFID .                               /*obtain optional argument from the CL.*/
if    n=='' |    n=="," then    n= 5             /*Not specified?  Then use the default.*/
if iFID=='' | iFID=="," then iFID='UNIXDICT.TXT' /* "      "         "   "   "     "    */
#= 0                                             /*number of semordnilaps  (so far).    */
@.=                                              /*caseless non─duplicated dict. words. */
    do while lines(iFID)\==0;  _= linein(iFID);  u= space(_, 0);  upper u  /*get a word.*/
    if length(u)<2 | @.u\==''  then iterate      /*word can't be a unique semordnilap.  */
    r= reverse(u)                                /*obtain reverse of the dictionary word*/
    if @.r\==''  then do;   #= # + 1             /*found a semordnilap word; bump count.*/
                            if #<=n  then say right(@.r,  max(32, length(@.r) ) )','   u
                      end
    @.u= _                                       /*define reverse of the dictionary word*/
    end   /*while*/                              /*stick a fork in it,  we're all done. */
say
say "There're "     #     ' unique semordnilap pairs in the dictionary file: '    iFID
