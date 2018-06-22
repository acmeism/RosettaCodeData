/* REXX ***************************************************************
* 27.10.2010 Walter Pachl
**********************************************************************/
Parse Arg fid
If fid='' Then Do
  "ALLOC FI(IN) DA('N561985.PRIV.V100(LL)') SHR REUSE"
  'EXECIO * DISKR IN (STEM L. FINIS'   /* read all lines             */
  'FREE FI(IN)'
  End
Else Do
  Do i=1 By 1 While lines(fid)>0
    l.i=linein(fid)
    End
  l.0=i-1
  End
maxl = 0                               /* initialize maximum length  */
Do i=1 To l.0                          /* loop through all lines     */
  linl=length(l.i)                     /* length of current line     */
  Select
    When linl>maxl Then Do             /* line longer than preceding */
      maxl=linl                        /* initialize maximum length  */
      mem.0=1                          /* memory has one entry       */
      mem.1=l.i                        /* the current line           */
      lin.1=i                          /* its line number            */
      End
    When linl=maxl Then Do             /* line as long as maximum    */
      z=mem.0+1                        /* new memory index           */
      mem.z=l.i                        /* the current line           */
      lin.z=i                          /* its line number            */
      mem.0=z                          /* memory size                */
      End
    Otherwise                          /* line is shorter than max.  */
      Nop                              /* ignore                     */
    End
  End
If mem.0>0 Then Do
  Say 'Maximum line length='maxl
  Say ' Line Contents'
  Do i=1 To mem.0
    Say right(lin.i,5) mem.i
    End
  End
Else
  Say 'No lines in input file or file does not exist'
