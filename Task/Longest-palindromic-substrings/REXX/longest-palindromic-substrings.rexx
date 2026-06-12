/*REXX program finds and displays the  longest palindromic string(s) in a given string. */
parse arg s                                      /*obtain optional argument from the CL.*/
if s==''|s==","  then s='babaccd rotator reverse forever several palindrome abaracadaraba'
                                                 /* [↑] the case of strings is respected*/
    do i=1  for words(s);          x= word(s, i) /*obtain a string to be examined.      */
    L= length(x);                  m= 0          /*get the string's length; Set max len.*/
                  do LL=2  for L-1               /*start with palindromes of length two.*/
                  if find(1)  then m= max(m, LL) /*Found a palindrome?  Set M=new length*/
                  end   /*LL*/
    LL= max(1, m)
    call find 0                                  /*find all palindromes with length  LL.*/
    say ' longest palindromic substrings for string: '        x
    say '────────────────────────────────────────────'copies('─', 2 + L)
          do n=1  for words(@)                   /*show longest palindromic substrings. */
          say '    (length='LL")  "  word(@, n)  /*display a         "      substring.  */
          end   /*n*/;       say;    say         /*display a two─blank separation fence.*/
    end         /*i*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
find: parse arg short                            /*if SHORT==1,  only find 1 palindrome.*/
      @=                                         /*initialize palindrome list to a null.*/
        do j=1  for L-LL+1;  $= substr(x, j, LL) /*obtain a possible palindromic substr.*/
        if $\==reverse($)  then iterate          /*Not a palindrome?       Then skip it.*/
        @= @ $                                   /*add a palindromic substring to a list*/
        if short  then return 1                  /*we have found  one   palindrome.     */
        end   /*j*/;   return 0                  /* "   "    "    some  palindrome(s).  */
