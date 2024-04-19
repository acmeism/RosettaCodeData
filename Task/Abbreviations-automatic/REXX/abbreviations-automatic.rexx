 /*REXX program finds the minimum length abbreviation for a lists of words (from a file).*/
iFID= 'ABBREV_A.TAB'                        /*name of the file that has the table.  */
Say 'minimum'                               /*display the first part of the title.  */
Say 'abbrev' center('days of the week',80)  /*display the title for the output.     */
Say '------' center('',80,'-')              /*display separator for the title line. */
                                            /* process the file until done.         */
Do While lines(iFID)\==0
  days=linein(iFID)                         /* read a line (should contain 7 words).*/
  If days='' Then                           /* check for a blank line or null line. */
    Say ''
  Else Do
    minLen=abb(days)                        /*find the minimum abbreviation length. */
    Say right(minLen,4) '  ' days           /*display a somewhat formatted output.  */
    If minlen='????' Then
      Say '           >>> No unique abbreviation found <<<'
    End
  End
Exit                                        /*stick a fork in it,we're all done.    */
/*----------------------------------------------------------------------------------*/
abb: Procedure
  Parse Arg daylist                         /* obtain list of words                 */
  dayn=words(daylist)                       /* find how many.                       */
  day.=''                                   /*day. is a stemmed array of the words. */
  L=0                                       /*L    is the max length  of the words. */
  Do j=1 for dayn
    day.j=word(daylist,j)                   /*assign to array for faster processing */
    L.j=length(day.j)
    L= max(L,L.j)                           /* find the maximum length of any item. */
    End
                                            /* [?]  determine minimum abbrev length */
  Do m=1 To L
    abblist=''                              /* for all lengths,find a unique abbrev  */
    Do k=1 to dayn
      abbrev=strip(left(day.k,m))           /* get an abbreviation (with length  M). */
      If wordpos(abbrev,abblist)>0 Then     /* not unique                            */
        Iterate M                           /* try next length                       */
      If length(abbrev)>=m Then
        abblist=abblist abbrev              /* so far,it's unique add to the list.   */
      End
    leave                                   /* a good abbreviation length was found. */
    End
  If m>L Then                               /* no unique abbreviation length found   */
    m='????'
  Return m
