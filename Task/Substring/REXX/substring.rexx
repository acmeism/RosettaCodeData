/*REXX program demonstrates various ways to extract substrings from a string of characters.  */
s='abcdefghijk';  n=4;  m=3   /*define come REXX constants (string, index, length of string).*/
say 'original string:' s      /* [↑]   M   can be  zero    (which indicates a null string).  */

u=substr(s,n,m)               /*starting from  N  characters in and of  M  length.           */
say u

u=substr(s,n)                 /*starting from  N  characters in,  up to the end-of-string.   */
say u

u=substr(s,1,length(s)-1)          /*OK:     the whole string  except  the last character.   */
u=substr(s,1,max(0,length(s)-1))   /*better: this version handles the case of a null string. */
say u

u=substr(s,pos('def',s),m)    /*starting from a known char   within the string & of M length.*/
say u

u=substr(s,pos('g',s),m)      /*starting from a known substr within the string & of M length.*/
say u
                              /*stick a fork in it sir, we're all done and Bob's your uncle. */
