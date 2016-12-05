/*REXX program lists all the  non─continuous subsequences  (NCS),  given a sequence.    */
parse arg list                                   /*obtain the arguments from the  C. L. */
if list='' | list==','  then list=1 2 3 4 5      /*Not specified?  Then use the default.*/
say 'list=' space(list);        say              /*display the list to the terminal.    */
w=words(list)                                    /*W:  is the number of items in list.  */
$=left(123456789, w)                             /*build a string of decimal digits.    */
tail=right($, max(0, w-2))                       /*construct a fast tail for comparisons*/
#=0                                              /* [↓]      L:   length of  Jth  item. */
    do j=13  to left($,1) || tail;  L=length(j)  /*step through list (using smart start)*/
    if verify(j, $)\==0  then iterate            /*Not one of the chosen  (sequences) ? */
    f=left(j,1)                                  /*use the fist decimal digit of  J.    */
    NCS=0                                        /*there isn't a non─continuous subseq. */
            do k=2  to L;      _=substr(j, k, 1) /*extract a single decimal digit of  J.*/
            if _ <=  f    then iterate j         /*if next digit ≤, then skip this digit*/
            if _ \== f+1  then NCS=1             /*it's OK as of now  (that is, so far).*/
            f=_                                  /*now have a  new  next decimal digit. */
            end   /*k*/

    if \NCS  then iterate                        /*not OK?  Then skip this number (item)*/
    #=#+1                                        /*Eureka!  We found a number (or item).*/
    @=;     do m=1  for L                        /*build a sequence string to display.  */
            @=@  word(list, substr(j, m, 1))     /*pick off a number (item) to display. */
            end   /*m*/

    say 'a non─continuous subsequence: '    @    /*show the non─continuous subsequence. */
    end         /*j*/
say
if #==0  then #='no'                             /*make it look more gooder Angleshy.   */
say  #  "non─continuous subsequence"s(#)     'were found.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:  if arg(1)==1  then return '';     return word(arg(2) 's', 1)           /*pluralizer.*/
