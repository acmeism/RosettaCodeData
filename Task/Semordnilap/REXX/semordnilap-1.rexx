/* REXX ***************************************************************
* 07.09.2012 Walter Pachl
**********************************************************************/
fid='unixdict.txt'                     /* the test dictionary        */
have.=''                               /* words encountered          */
pi=0                                   /* number of palindromes      */
Do li=1 By 1 While lines(fid)>0        /* as long there is input     */
  w=linein(fid)                        /* read a word                */
  If w>'' Then Do                      /* not a blank line           */
    r=reverse(w)                       /* reverse it                 */
    If have.r>'' Then Do               /* was already encountered    */
      pi=pi+1                          /* increment number of pal's  */
      If pi<=5 Then                    /* the first 5 ale listed     */
        Say have.r w
      End
    have.w=w                           /* remember the word          */
    End
  End
Say pi 'words in' fid 'have a palindrome' /* total number found      */
