/* REXX ---------------------------------------------------------------
* 09.08.2014 Walter Pachl 'copied' from REXX
* lists the # of chars in fibonacci words and the words' entropy
* as well as (part of) the Fibonacci word and the number of 0's and 1's
* Note: ooRexx allows for computing up to 47 Fibonacci words
*--------------------------------------------------------------------*/
  Numeric Digits 20                /* use more precision,  default=9.*/
  Parse Arg n fw.1 fw.2 .          /* get optional args from the C.L.*/
  If n=='' Then n=50               /* Not specified? Then use default*/
  If fw.1=='' Then fw.1=1          /* "      "        "   "     "    */
  If fw.2=='' Then fw.2=0          /* "      "        "   "     "    */
  hdr1=' N     length  Entropy                 Fibonacci word    ',
                                                '# of zeroes # of ones'
  hdr2='-- ----------  ----------------------  --------------------',
                                                  '--------- ---------'
  Say hdr1
  Say hdr2
  Do j=1 For n                     /* display  N  fibonacci words.   */
    j1=j-1
    j2=j-2
    If j>2 Then                    /* calculate FIBword if we need to*/
      fw.j=fw.j1||fw.j2
    If length(fw.j)<20 Then
      fwd=left(fw.j,20)            /* display the Fibonacci word     */
    Else
      fwd=left(fw.j,5)'...'right(fw.j,12) /* display parts thereof   */
    Say right(j,2)'  'right(length(fw.j),9)'  'entropy(fw.j)'  'fwd,
                                            right(aa.0,9) right(aa.1,9)
    End
  Say hdr2
  Say hdr1
  Exit

entropy: Procedure Expose aa.
  Parse Arg dd
  l=length(dd)
  d=digits()
  aa.0=l-length(space(translate(dd,,0),0)) /*fast way to count zeroes*/
  aa.1=l-aa.0                      /* and figure the number of ones. */
  If l==1 Then
    Return left(0,d+2)             /* handle special case of one char*/
  s=0                              /* [?] calc entropy for each char */
  do i=1 for 2
    _=i-1                          /* construct a chr from the ether.*/
    p=aa._/l                       /* 'probability of aa-_ in fw     */
    s=s-p*rxmlog(p,d,2)            /* add (negatively) the entropies.*/
    End
  If s=1 Then
    Return left(1,d+2)             /* return a left-justified  "1".  */
  Return format(s,,d)              /* normalize the number (sum or S)*/
::requires rxm.cls
